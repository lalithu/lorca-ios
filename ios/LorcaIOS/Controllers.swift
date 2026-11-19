import UIKit
import PhotosUI
import Vision

final class NotesViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating {
    @IBOutlet private weak var tableView:UITableView!
    @IBOutlet private weak var emptyLabel:UILabel!
    private let search=UISearchController(searchResultsController:nil)
    private var visible:[Note]=[]
    override func viewDidLoad() {
        super.viewDidLoad();title="Notes"
        navigationController?.navigationBar.prefersLargeTitles=true
        tableView.dataSource=self;tableView.delegate=self;tableView.rowHeight=84
        tableView.register(UITableViewCell.self,forCellReuseIdentifier:"Note")
        tableView.accessibilityIdentifier="notesList"
        search.searchResultsUpdater=self;search.obscuresBackgroundDuringPresentation=false;search.searchBar.placeholder="Search notes"
        navigationItem.searchController=search;definesPresentationContext=true
        NotificationCenter.default.addObserver(self,selector:#selector(reload),name:.notesChanged,object:nil)
        reload()
    }
    override func viewWillAppear(_ animated:Bool) { super.viewWillAppear(animated);reload() }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func reload() {
        let query=search.searchBar.text ?? ""
        visible=NotesStore.shared.notes.filter{query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) || $0.text.localizedCaseInsensitiveContains(query)}
        tableView.reloadData();emptyLabel.isHidden = !visible.isEmpty
        emptyLabel.text=NotesStore.shared.error ?? (query.isEmpty ? "Your thoughts, with room to grow.\nTap + to write your first note." : "No matching notes.")
    }
    func updateSearchResults(for searchController:UISearchController) { reload() }
    @IBAction private func newNote(_ sender:Any) { show(NotesStore.shared.create().id) }
    @IBAction private func settings(_ sender:Any) { presentSettings(from:self) }
    private func show(_ id:UUID) {
        let vc=storyboard!.instantiateViewController(withIdentifier:"NoteEditor") as! NoteEditorViewController
        vc.noteID=id;navigationController?.pushViewController(vc,animated:true)
    }
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int { visible.count }
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath)->UITableViewCell {
        let note=visible[indexPath.row],cell=tableView.dequeueReusableCell(withIdentifier:"Note",for:indexPath)
        var content=cell.defaultContentConfiguration();content.text=note.title;content.textProperties.font = .preferredFont(forTextStyle:.headline)
        let preview=note.text.split(whereSeparator:\.isNewline).dropFirst().prefix(2).joined(separator:" ")
        content.secondaryText=DateFormatter.localizedString(from:note.updatedAt,dateStyle:.short,timeStyle:.short)+(preview.isEmpty ? " · Empty note" : " · "+preview)
        content.secondaryTextProperties.numberOfLines=2;content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration=content;cell.accessoryType = .disclosureIndicator;return cell
    }
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath) { tableView.deselectRow(at:indexPath,animated:true);show(visible[indexPath.row].id) }
    func tableView(_ tableView:UITableView,trailingSwipeActionsConfigurationForRowAt indexPath:IndexPath)->UISwipeActionsConfiguration? {
        let note=visible[indexPath.row]
        let rename=UIContextualAction(style:.normal,title:"Rename") { [weak self] _,_,done in
            let alert=UIAlertController(title:"Rename note",message:nil,preferredStyle:.alert)
            alert.addTextField{$0.text=note.title}
            alert.addAction(UIAlertAction(title:"Cancel",style:.cancel))
            alert.addAction(UIAlertAction(title:"Save",style:.default){[weak alert] _ in
                guard var current=NotesStore.shared.note(note.id),let title=alert?.textFields?.first?.text?.trimmingCharacters(in:.whitespacesAndNewlines),!title.isEmpty else{return}
                current.title=String(title.prefix(80));NotesStore.shared.update(current)
            });self?.present(alert,animated:true);done(true)
        }
        rename.backgroundColor = .systemBlue
        let delete=UIContextualAction(style:.destructive,title:"Delete") { [weak self] _,_,done in
            let alert=UIAlertController(title:"Delete note?",message:"Delete ‘\(note.title)’ from this iPhone? This does not change your Mac notes.",preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:"Cancel",style:.cancel));alert.addAction(UIAlertAction(title:"Delete",style:.destructive){_ in NotesStore.shared.delete(note.id)})
            self?.present(alert,animated:true);done(true)
        }
        let actions=UISwipeActionsConfiguration(actions:[delete,rename]);actions.performsFirstActionWithFullSwipe=false;return actions
    }
}

@MainActor enum NoteDocuments {
    static var documents:[UUID:NoteDocument]=[:]
    static func get(_ id:UUID)->NoteDocument {
        if let document=documents[id] { return document }
        let document=NoteDocument(NotesStore.shared.note(id)!);documents[id]=document;return document
    }
}

final class NoteEditorViewController:UIViewController,PHPickerViewControllerDelegate {
    var noteID:UUID!
    @IBOutlet private weak var editorContainer:UIView!
    @IBOutlet private weak var statusButton:UIButton!
    @IBOutlet private weak var activity:UIActivityIndicatorView!
    private var document:NoteDocument!
    override func viewDidLoad() {
        super.viewDidLoad();document=NoteDocuments.get(noteID);title=NotesStore.shared.note(noteID)?.title ?? "Note"
        navigationItem.largeTitleDisplayMode = .never
        let editor=document.editor;editor.removeFromSuperview();editor.translatesAutoresizingMaskIntoConstraints=false;editorContainer.addSubview(editor)
        NSLayoutConstraint.activate([editor.leadingAnchor.constraint(equalTo:editorContainer.leadingAnchor),editor.trailingAnchor.constraint(equalTo:editorContainer.trailingAnchor),editor.topAnchor.constraint(equalTo:editorContainer.topAnchor),editor.bottomAnchor.constraint(equalTo:editorContainer.bottomAnchor)])
        // Keep the storyboard's editor/status region above the software keyboard.
        view.constraints.filter{$0.identifier=="editor-bottom"}.forEach{$0.isActive=false}
        statusButton.bottomAnchor.constraint(equalTo:view.keyboardLayoutGuide.topAnchor,constant:-8).isActive=true
        let toolbar=UIToolbar();toolbar.sizeToFit()
        let undo=UIBarButtonItem(image:UIImage(systemName:"arrow.uturn.backward"),style:.plain,target:self,action:#selector(undo))
        let redo=UIBarButtonItem(image:UIImage(systemName:"arrow.uturn.forward"),style:.plain,target:self,action:#selector(redo))
        toolbar.items=[undo,redo,.flexibleSpace(),UIBarButtonItem(title:"Done",style:.done,target:self,action:#selector(done))]
        editor.inputAccessoryView=toolbar
        document.statusChanged={ [weak self] text in self?.updateStatus(text) }
        updateStatus(document.status);document.begin()
        navigationItem.rightBarButtonItems=[UIBarButtonItem(image:UIImage(systemName:"photo"),style:.plain,target:self,action:#selector(photo)),UIBarButtonItem(image:UIImage(systemName:"gearshape"),style:.plain,target:self,action:#selector(settings))]
        if editor.text.isEmpty { editor.becomeFirstResponder() }
    }
    override func viewWillDisappear(_ animated:Bool){super.viewWillDisappear(animated);document.save()}
    private func updateStatus(_ text:String) {
        if let note=NotesStore.shared.note(noteID) { title=note.title }
        let busy=text=="Thinking…" || text=="Reading image…"
        statusButton.setTitle(text,for:.normal);statusButton.titleLabel?.numberOfLines=2
        busy ? activity.startAnimating() : activity.stopAnimating()
        statusButton.accessibilityLabel=text
    }
    @IBAction private func modelOptions(_ sender:Any) {
        let menu=UIAlertController(title:"Model following",message:document.status,preferredStyle:.actionSheet)
        menu.addAction(UIAlertAction(title:document.paused ? "Resume" : "Pause",style:.default){[weak self] _ in guard let self else{return};self.document.paused.toggle()})
        menu.addAction(UIAlertAction(title:"Retry failed work",style:.default){[weak self] _ in self?.document.retry()})
        menu.addAction(UIAlertAction(title:"Connection Settings",style:.default){[weak self] _ in self?.settings()})
        menu.addAction(UIAlertAction(title:"Cancel",style:.cancel));menu.popoverPresentationController?.sourceView=statusButton;present(menu,animated:true)
    }
    @objc private func undo(){document.editor.undoManager?.undo();document.save()}
    @objc private func redo(){document.editor.undoManager?.redo();document.save()}
    @objc private func done(){document.editor.resignFirstResponder()}
    @objc private func settings(){presentSettings(from:self)}
    @objc private func photo(){
        var configuration=PHPickerConfiguration();configuration.filter = .images;configuration.selectionLimit=1
        let picker=PHPickerViewController(configuration:configuration);picker.delegate=self;present(picker,animated:true)
    }
    func picker(_ picker:PHPickerViewController,didFinishPicking results:[PHPickerResult]) {
        picker.dismiss(animated:true)
        guard let provider=results.first?.itemProvider,provider.canLoadObject(ofClass:UIImage.self) else{return}
        let document=self.document!
        updateStatus("Reading image…")
        provider.loadObject(ofClass:UIImage.self){[weak self] object,error in
            guard let image=object as? UIImage,let cg=image.cgImage else{return}
            let request=VNRecognizeTextRequest();request.recognitionLevel = .accurate
            do {
                try VNImageRequestHandler(cgImage:cg).perform([request])
                let text=(request.results ?? []).compactMap{$0.topCandidates(1).first?.string}.joined(separator:"\n")
                Task{@MainActor in
                    guard self != nil else{return}
                    guard !text.isEmpty else{self?.updateStatus("No readable text found. Try a clearer screenshot.");return}
                    let attachment=NSTextAttachment()
                    let scale=min(1,300/max(image.size.width,image.size.height))
                    let target=CGSize(width:image.size.width*scale,height:image.size.height*scale)
                    attachment.image=UIGraphicsImageRenderer(size:target).image{_ in image.draw(in:CGRect(origin:.zero,size:target))}
                    attachment.bounds=CGRect(origin:.zero,size:target)
                    let content=NSMutableAttributedString(string:"\n\nImage\n")
                    content.append(NSAttributedString(attachment:attachment));content.append(NSAttributedString(string:"\n\nSummarize this screenshot:\n"+String(text.prefix(4000))+"\n\n"))
                    document.replace(document.editor.selectedRange,with:content);document.begin()
                }
            }catch{Task{@MainActor in self?.updateStatus("Could not read the screenshot. Your note is saved.")}}
        }
    }
}

final class ConnectionSettingsViewController:UIViewController {
    @IBOutlet private weak var addressField:UITextField!
    @IBOutlet private weak var modelField:UITextField!
    @IBOutlet private weak var statusLabel:UILabel!
    @IBOutlet private weak var connectButton:UIButton!
    private var testing:Task<Void,Never>?
    override func viewDidLoad(){super.viewDidLoad();let profile=ConnectionProfile();addressField.text=profile.address;modelField.text=profile.model;statusLabel.text="Connect to Ollama on your Mac. Notes always save on this iPhone.";addressField.accessibilityIdentifier="serverAddress";modelField.accessibilityIdentifier="modelName"}
    @IBAction private func connect(_ sender:Any){
        var profile=ConnectionProfile();profile.address=addressField.text?.trimmingCharacters(in:.whitespacesAndNewlines) ?? "";profile.model=modelField.text?.trimmingCharacters(in:.whitespacesAndNewlines) ?? ""
        guard !profile.model.isEmpty else{statusLabel.text="Enter an installed model name.";return}
        view.endEditing(true);connectButton.isEnabled=false;statusLabel.text="Connecting…";UserDefaults.standard.set(false,forKey:"lorca.ios.connected")
        testing=Task{[weak self] in
            do{
                let models=try await LocalModelClient.test(profile)
                guard !Task.isCancelled else{return}
                guard models.contains(profile.model) || models.contains(profile.model+":latest") else{throw NotesError("Connected to Ollama, but ‘\(profile.model)’ is not installed. Available: "+models.joined(separator:", "))}
                UserDefaults.standard.set(true,forKey:"lorca.ios.connected");self?.statusLabel.text="Connected · "+profile.model+"\nYou can return to your notes."
            }catch{self?.statusLabel.text=error.localizedDescription}
            self?.connectButton.isEnabled=true
        }
    }
    @IBAction private func disconnect(_ sender:Any){testing?.cancel();UserDefaults.standard.set(false,forKey:"lorca.ios.connected");statusLabel.text="Disconnected. Your notes remain saved and editable.";connectButton.isEnabled=true}
    @IBAction private func done(_ sender:Any){dismiss(animated:true)}
}
private func presentSettings(from controller:UIViewController){controller.present(controller.storyboard!.instantiateViewController(withIdentifier:"SettingsNavigation"),animated:true)}
