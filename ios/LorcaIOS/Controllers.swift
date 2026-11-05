import UIKit

struct Conversation: Codable {
    let id: UUID
    var title: String
    var draft: String
}

final class ConversationStore {
    static let shared = ConversationStore()
    private let key = "lorca.ios.conversations.v1"
    private(set) var conversations: [Conversation] = []

    private init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Conversation].self, from: data) {
            conversations = saved
        }
    }

    @discardableResult func create() -> UUID {
        let item = Conversation(id: UUID(), title: "New conversation", draft: "")
        conversations.insert(item, at: 0)
        save()
        return item.id
    }

    func item(_ id: UUID) -> Conversation? { conversations.first { $0.id == id } }
    func rename(_ id: UUID, title: String) {
        guard let index = conversations.firstIndex(where: { $0.id == id }) else { return }
        conversations[index].title = title
        save()
    }
    func updateDraft(_ id: UUID, draft: String) {
        guard let index = conversations.firstIndex(where: { $0.id == id }) else { return }
        conversations[index].draft = draft
        save()
    }
    func delete(_ id: UUID) {
        conversations.removeAll { $0.id == id }
        save()
    }
    private func save() {
        if let data = try? JSONEncoder().encode(conversations) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

final class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyLabel: UILabel!
    private let store = ConversationStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Conversation")
        tableView.accessibilityIdentifier = "conversationList"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        emptyLabel.isHidden = !store.conversations.isEmpty
    }
    @IBAction private func newChat(_ sender: Any) {
        showChat(store.create())
    }
    private func showChat(_ id: UUID) {
        let chat = storyboard!.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
        chat.conversationID = id
        navigationController?.pushViewController(chat, animated: true)
    }
    @IBAction private func settings(_ sender: Any) { presentSettings(from: self) }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { store.conversations.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = store.conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.draft.isEmpty ? "No messages yet • local conversation" : "Draft: \(item.draft)"
        config.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showChat(store.conversations[indexPath.row].id)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = store.conversations[indexPath.row]
        let rename = UIContextualAction(style: .normal, title: "Rename") { [weak self] _, _, done in
            self?.rename(item); done(true)
        }
        rename.backgroundColor = .systemBlue
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.confirmDelete(item); done(true)
        }
        let actions = UISwipeActionsConfiguration(actions: [delete, rename])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    private func rename(_ item: Conversation) {
        let alert = UIAlertController(title: "Rename conversation", message: "Choose a title for this local conversation.", preferredStyle: .alert)
        alert.addTextField { $0.text = item.title; $0.placeholder = "Conversation title" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let title = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else { return }
            self?.store.rename(item.id, title: title)
            self?.tableView.reloadData()
        })
        present(alert, animated: true)
    }
    private func confirmDelete(_ item: Conversation) {
        let alert = UIAlertController(title: "Delete conversation?", message: "Delete ‘\(item.title)’ from this iPhone? Your Mac library is unchanged.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.store.delete(item.id)
            self?.tableView.reloadData()
            self?.emptyLabel.isHidden = !(self?.store.conversations.isEmpty ?? true)
        })
        present(alert, animated: true)
    }
}

final class ChatViewController: UIViewController, UITextViewDelegate {
    var conversationID: UUID!
    @IBOutlet private weak var draftView: UITextView!
    @IBOutlet private weak var draftStatus: UILabel!
    @IBOutlet private weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = ConversationStore.shared.item(conversationID)
        title = item?.title ?? "Chat"
        draftView.text = item?.draft ?? ""
        draftView.delegate = self
        draftView.layer.cornerRadius = 12
        draftView.layer.borderColor = UIColor.separator.cgColor
        draftView.layer.borderWidth = 1
        draftView.accessibilityLabel = "Message draft"
        draftView.accessibilityIdentifier = "messageDraft"
        sendButton.isEnabled = false
        draftStatus.text = draftView.text.isEmpty ? "Write a message below. Drafts save on this iPhone." : "Draft restored from this iPhone."
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
    }
    @objc private func dismissKeyboard() { draftView.resignFirstResponder() }
    func textViewDidChange(_ textView: UITextView) {
        ConversationStore.shared.updateDraft(conversationID, draft: textView.text)
        draftStatus.text = "Draft saved on this iPhone."
    }
    @IBAction private func connectionSettings(_ sender: Any) {
        draftView.resignFirstResponder()
        presentSettings(from: self)
    }
}

final class ConnectionSettingsViewController: UIViewController {
    @IBOutlet private weak var addressField: UITextField!
    @IBOutlet private weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.text = UserDefaults.standard.string(forKey: "lorca.ios.macAddress")
        addressField.accessibilityIdentifier = "macAddress"
        updateStatus()
    }
    @IBAction private func saveAddress(_ sender: Any) {
        let address = addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !address.isEmpty else {
            statusLabel.text = "Enter a Mac address first."
            return
        }
        UserDefaults.standard.set(address, forKey: "lorca.ios.macAddress")
        addressField.resignFirstResponder()
        statusLabel.text = "Address saved. Connection is not implemented yet."
    }
    @IBAction private func disconnect(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "lorca.ios.macAddress")
        addressField.text = ""
        statusLabel.text = "Saved address cleared. Not connected."
    }
    @IBAction private func done(_ sender: Any) { dismiss(animated: true) }
    private func updateStatus() {
        statusLabel.text = (addressField.text?.isEmpty == false) ? "Saved address restored. Not connected." : "Not connected. Mac integration is coming next."
    }
}

private func presentSettings(from controller: UIViewController) {
    let navigation = controller.storyboard!.instantiateViewController(withIdentifier: "SettingsNavigation")
    controller.present(navigation, animated: true)
}
