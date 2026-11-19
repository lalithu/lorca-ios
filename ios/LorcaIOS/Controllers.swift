import UIKit
import PhotosUI
import Vision

final class NotesViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating {
    @IBOutlet private weak var tableView:UITableView!
    @IBOutlet private weak var emptyLabel:UILabel!
    private let search=UISearchController(searchResultsController:nil)
    private var visible:[Note]=[]
    private var openedCanvas=false
    override func viewDidLoad() {
        super.viewDidLoad();title="Notes"
        navigationController?.navigationBar.prefersLargeTitles=true
        let appearance=UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        let heading=UIFont.systemFont(ofSize:38,weight:.bold)
        appearance.largeTitleTextAttributes=[.font:UIFont(descriptor:heading.fontDescriptor.withDesign(.serif) ?? heading.fontDescriptor,size:38)]
        appearance.shadowColor = .clear
        navigationController?.navigationBar.directionalLayoutMargins=NSDirectionalEdgeInsets(top:0,leading:22,bottom:0,trailing:22)
        navigationController?.navigationBar.standardAppearance=appearance
        navigationController?.navigationBar.scrollEdgeAppearance=appearance
        navigationItem.leftBarButtonItem?.title=nil
        navigationItem.leftBarButtonItem?.image=UIImage(systemName:"gearshape")
        navigationItem.leftBarButtonItem?.accessibilityLabel="Settings"
        tableView.dataSource=self;tableView.delegate=self
        tableView.rowHeight=UITableView.automaticDimension;tableView.estimatedRowHeight=84
        tableView.directionalLayoutMargins=NSDirectionalEdgeInsets(top:0,leading:20,bottom:0,trailing:20)
        tableView.cellLayoutMarginsFollowReadableWidth=true
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .preferredFont(forTextStyle:.body);emptyLabel.adjustsFontForContentSizeCategory=true
        tableView.register(UITableViewCell.self,forCellReuseIdentifier:"Note")
        tableView.accessibilityIdentifier="notesList"
        search.searchResultsUpdater=self;search.obscuresBackgroundDuringPresentation=false;search.searchBar.placeholder="Search notes"
        navigationItem.searchController=search;definesPresentationContext=true
        NotificationCenter.default.addObserver(self,selector:#selector(reload),name:.notesChanged,object:nil)
        reload()
    }
    override func viewWillAppear(_ animated:Bool) { super.viewWillAppear(animated);reload() }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        guard !openedCanvas else { return };openedCanvas=true
        guard NotesStore.shared.error == nil else { return }
        let saved=UserDefaults.standard.string(forKey:"lorca.ios.openNote").flatMap(UUID.init(uuidString:))
        let note=saved.flatMap{NotesStore.shared.note($0)} ?? NotesStore.shared.notes.first ?? NotesStore.shared.create()
        show(note.id,animated:false)
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func reload() {
        let query=search.searchBar.text ?? ""
        visible=NotesStore.shared.notes.filter{query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) || $0.text.localizedCaseInsensitiveContains(query)}
        tableView.reloadData();emptyLabel.isHidden = !visible.isEmpty
        emptyLabel.text=NotesStore.shared.error ?? (query.isEmpty ? "Your thoughts, with room to grow.\nTap + to write your first note." : "No matching notes.")
    }
    func updateSearchResults(for searchController:UISearchController) { reload() }
    @IBAction private func newNote(_ sender:Any) { show(NotesStore.shared.create().id,focus:true) }
    @IBAction private func settings(_ sender:Any) { presentSettings(from:self) }
    private func show(_ id:UUID,animated:Bool=true,focus:Bool=true) {
        let vc=storyboard!.instantiateViewController(withIdentifier:"NoteEditor") as! NoteEditorViewController
        vc.noteID=id;vc.focusOnOpen=focus;navigationController?.pushViewController(vc,animated:animated)
    }
    func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int)->Int { visible.count }
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath)->UITableViewCell {
        let note=visible[indexPath.row],cell=tableView.dequeueReusableCell(withIdentifier:"Note",for:indexPath)
        var content=cell.defaultContentConfiguration();content.text=note.title;content.textProperties.font = .preferredFont(forTextStyle:.headline)
        let preview=note.text.split(whereSeparator:\.isNewline).dropFirst().prefix(2).joined(separator:" ")
        content.secondaryText=DateFormatter.localizedString(from:note.updatedAt,dateStyle:.short,timeStyle:.short)+(preview.isEmpty ? " · Empty note" : " · "+preview)
        content.secondaryTextProperties.numberOfLines=2;content.secondaryTextProperties.color = .secondaryLabel
        content.textProperties.numberOfLines=2
        content.directionalLayoutMargins=NSDirectionalEdgeInsets(top:16,leading:0,bottom:16,trailing:0)
        cell.preservesSuperviewLayoutMargins=true
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
    var focusOnOpen=false
    private let wordCount=UILabel()
    @IBOutlet private weak var editorContainer:UIView!
    @IBOutlet private weak var statusButton:UIButton!
    @IBOutlet private weak var activity:UIActivityIndicatorView!
    private var document:NoteDocument!
    override func viewDidLoad() {
        super.viewDidLoad();document=NoteDocuments.get(noteID);title="Notes"
        UserDefaults.standard.set(noteID.uuidString,forKey:"lorca.ios.openNote")
        navigationItem.largeTitleDisplayMode = .always
        var statusStyle=UIButton.Configuration.plain()
        statusStyle.image=UIImage(systemName:"sparkles");statusStyle.imagePadding=7
        statusStyle.preferredSymbolConfigurationForImage=UIImage.SymbolConfiguration(pointSize:15,weight:.regular,scale:.small)
        statusStyle.contentInsets=NSDirectionalEdgeInsets(top:8,leading:0,bottom:8,trailing:0)
        statusStyle.titleTextAttributesTransformer=UIConfigurationTextAttributesTransformer { incoming in
            var attributes=incoming;attributes.font=UIFont.preferredFont(forTextStyle:.footnote);return attributes
        }
        statusButton.configuration=statusStyle;statusButton.contentHorizontalAlignment = .leading
        statusButton.heightAnchor.constraint(greaterThanOrEqualToConstant:44).isActive=true
        view.constraints.first{$0.identifier=="constraint-12"}?.constant=22
        wordCount.font = .preferredFont(forTextStyle:.caption1);wordCount.textColor = .secondaryLabel
        wordCount.adjustsFontForContentSizeCategory=true
        wordCount.translatesAutoresizingMaskIntoConstraints=false;view.addSubview(wordCount)
        wordCount.setContentCompressionResistancePriority(.required,for:.horizontal)
        NSLayoutConstraint.activate([wordCount.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor,constant:-20),wordCount.centerYAnchor.constraint(equalTo:statusButton.centerYAnchor)])
        view.constraints.first{$0.identifier=="constraint-13"}?.constant=105
        NotificationCenter.default.addObserver(self,selector:#selector(updateWordCount),name:.notesChanged,object:nil)
        let editor=document.editor;editor.removeFromSuperview();editor.translatesAutoresizingMaskIntoConstraints=false;editorContainer.addSubview(editor)
        NSLayoutConstraint.activate([editor.leadingAnchor.constraint(equalTo:editorContainer.leadingAnchor),editor.trailingAnchor.constraint(equalTo:editorContainer.trailingAnchor),editor.topAnchor.constraint(equalTo:editorContainer.topAnchor),editor.bottomAnchor.constraint(equalTo:editorContainer.bottomAnchor)])
        // Keep the storyboard's editor/status region above the software keyboard.
        view.constraints.filter{$0.identifier=="editor-bottom"}.forEach{$0.isActive=false}
        statusButton.bottomAnchor.constraint(equalTo:view.keyboardLayoutGuide.topAnchor,constant:-8).isActive=true
        let toolbar=UIToolbar();toolbar.sizeToFit()
        let toolbarAppearance=UIToolbarAppearance();toolbarAppearance.configureWithDefaultBackground()
        toolbarAppearance.backgroundColor = .systemBackground
        toolbarAppearance.shadowColor = .separator.withAlphaComponent(0.2)
        toolbar.standardAppearance=toolbarAppearance;toolbar.scrollEdgeAppearance=toolbarAppearance
        let iconStyle=UIImage.SymbolConfiguration(pointSize:18,weight:.regular,scale:.medium)
        let undo=UIBarButtonItem(image:UIImage(systemName:"arrow.uturn.backward",withConfiguration:iconStyle),style:.plain,target:self,action:#selector(undo))
        let redo=UIBarButtonItem(image:UIImage(systemName:"arrow.uturn.forward",withConfiguration:iconStyle),style:.plain,target:self,action:#selector(redo))
        undo.accessibilityLabel="Undo";redo.accessibilityLabel="Redo"
        let photoButton=UIBarButtonItem(image:UIImage(systemName:"photo",withConfiguration:iconStyle),style:.plain,target:self,action:#selector(photo))
        photoButton.accessibilityLabel="Add screenshot"
        undo.width=44;redo.width=44;photoButton.width=44
        let inset=UIBarButtonItem(barButtonSystemItem:.fixedSpace,target:nil,action:nil);inset.width=8
        let trailingInset=UIBarButtonItem(barButtonSystemItem:.fixedSpace,target:nil,action:nil);trailingInset.width=8
        let doneButton=UIBarButtonItem(title:"Done",style:.plain,target:self,action:#selector(done))
        doneButton.setTitleTextAttributes([.font:UIFont.preferredFont(forTextStyle:.subheadline)],for:.normal)
        toolbar.items=[inset,undo,redo,photoButton,.flexibleSpace(),doneButton,trailingInset]
        editor.inputAccessoryView=toolbar
        document.statusChanged={ [weak self] text in self?.updateStatus(text) }
        updateStatus(document.status);document.begin()
        let newButton=UIBarButtonItem(title:"New note",style:.plain,target:self,action:#selector(newNote))
        newButton.accessibilityLabel="New note"
        let listButton=UIBarButtonItem(image:UIImage(systemName:"sidebar.left"),style:.plain,target:self,action:#selector(showNotes))
        listButton.accessibilityLabel="Saved notes";navigationItem.leftBarButtonItem=listButton
        let settingsButton=UIBarButtonItem(image:UIImage(systemName:"gearshape"),style:.plain,target:self,action:#selector(settings))
        settingsButton.accessibilityLabel="Connection Settings"
        navigationItem.rightBarButtonItems=[settingsButton,newButton]
    }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        guard focusOnOpen else { return };focusOnOpen=false
        document.editor.becomeFirstResponder()
        document.editor.scrollRangeToVisible(document.editor.selectedRange)
    }
    override func viewWillDisappear(_ animated:Bool){super.viewWillDisappear(animated);document.save()}
    private func updateStatus(_ text:String) {
        updateWordCount()
        let busy=text=="Thinking…" || text=="Reading image…"
        var style=statusButton.configuration;style?.title=text;statusButton.configuration=style
        statusButton.titleLabel?.numberOfLines=2
        busy ? activity.startAnimating() : activity.stopAnimating()
        wordCount.isHidden=busy
        statusButton.accessibilityLabel=text
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    @objc private func updateWordCount() {
        let count=document.editor.text.split(whereSeparator:{$0.isWhitespace}).count
        wordCount.text="\(count) \(count == 1 ? "word" : "words")"
    }
    @objc private func showNotes(){navigationController?.popViewController(animated:true)}
    @objc private func newNote(){
        document.save()
        let vc=storyboard!.instantiateViewController(withIdentifier:"NoteEditor") as! NoteEditorViewController
        vc.noteID=NotesStore.shared.create().id;vc.focusOnOpen=true
        if let navigationController { navigationController.setViewControllers([navigationController.viewControllers[0],vc],animated:false) }
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
    override func viewDidLoad(){super.viewDidLoad();let profile=ConnectionProfile();addressField.text=profile.address;modelField.text=profile.model;statusLabel.text="Connect to Ollama on your Mac. Notes always save on this iPhone.";addressField.accessibilityIdentifier="serverAddress";modelField.accessibilityIdentifier="modelName"
        navigationItem.largeTitleDisplayMode = .never
        var connectStyle:UIButton.Configuration
        if #available(iOS 26.0, *) { connectStyle = .prominentGlass() }
        else { connectStyle = .filled() }
        connectStyle.title="Test & Connect";connectStyle.cornerStyle = .capsule;connectStyle.buttonSize = .large
        connectButton.configuration=connectStyle
        statusLabel.textColor = .secondaryLabel
    }
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
