# Kubernetes Multi-Pod Exec with tmux

This script allows you to **open a tmux session** and execute `kubectl exec` into **all pods within a specified Kubernetes namespace**. Each pod gets a separate tmux pane, making it easy to **manage multiple pods simultaneously**.

---

## 🚀 Features

✔ **Automatically connects to all pods** in a given namespace.\
✔ **Creates a separate tmux pane** for each pod.\
✔ **Maintains a neat tiled layout** for better visibility.\
✔ **Supports synchronized input** (execute commands across all pods at once).\
✔ **Easily detaches or exits when done**.

---

## 📌 Prerequisites

Ensure you have the following installed:

- **kubectl** (configured to access your Kubernetes cluster)
- **tmux**

To check if they are installed, run:

```sh
kubectl version --client
```

```sh
which tmux
```

---

## 📜 Installation

### Homebrew

```sh
brew tap --force-auto-update linushall/kubemax
```

```sh
brew install kubemax
```

### Manually

1. **Clone the repository** (or download the script directly):

   ```sh
   git clone https://github.com/linushall/kubemux.git
   ```
   
   ```sh
   cd kubemux
   ```

2. **Make the script executable:**

   ```sh
   chmod +x kubemax.sh
   ```

3. **Create symlink**

   ```sh
   sudo ln -s "$(pwd)/kubemax.sh" /usr/local/bin/kubemax
   ```

---

## 🛠 Usage

Run the script with the desired Kubernetes namespace:

```sh
./kubemax -n <namespace>
```

or 

```sh
./kubemax -l <label>
```

or

```sh
./kubemax -n <namespace> -l <label>
```

### 1st example:

```sh
./kubemax -n web
```

This will:

- Open a **new tmux session** named `kubemax-web`
- Execute into all pods within the `web` namespace
- Tile all tmux panes for better visibility
- Enable **synchronized input** across all panes

### 2nd example:

```sh
./kubemax -n web -l part=first
```

This will:

- Open a **new tmux session** named `kubemax-web`
- Execute into all pods within the `web` namespace and label `part: first`
- Tile all tmux panes for better visibility
- Enable **synchronized input** across all panes

---

## 🔧 Controls & Shortcuts

| Action                  | Shortcut                                            |
|-------------------------|-----------------------------------------------------|
| **Detach from tmux**    | `Ctrl + b`, then `d`                                |
| **Kill session**        | `Ctrl + d` in all panes                             |
| **List sessions**       | `tmux ls`                                           |
| **Disconnect all pods** | `exit` in each pane or `Ctrl + d`                   |
| **Disable sync input**  | `Ctrl + b`, then `:` → `setw synchronize-panes off` |
| **Show pane number**    | `Ctrl + b + q`                                      |
| **Select pane**         | `Ctrl + b + q + <number>`                           |
| **Enable sync input**   | `Ctrl + b`, then `:` → `setw synchronize-panes on`  |

---

## 🛠 Troubleshooting

### 1️⃣ "No pods found in namespace: "

✅ Make sure the namespace is correct:

```sh
kubectl get namespaces
kubectl get pods -n <namespace>
```

### 2️⃣ "Command not found: tmux"

✅ Install `tmux`:

```sh
sudo apt install tmux   # Debian/Ubuntu
brew install tmux       # macOS
sudo dnf install tmux   # Fedora
```

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to modify and use it as needed!

---

## 🙌 Contributions

Pull requests are welcome! If you find a bug or have an idea for improvement, feel free to contribute.

---

## 📬 Contact

For questions or suggestions, reach out via GitHub Issues or email: [**ask.linushall@gmail.com**](mailto\:ask.linushall@gmail.com)

---

🚀 Happy Kubernetes managing with kubemax! 🎉

