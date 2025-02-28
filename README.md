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
which tmux
```

---

## 📜 Installation

1. **Clone the repository** (or download the script directly):

   ```sh
   git clone https://github.com/linushall/k8s-tmux.git
   cd k8s-tmux
   ```

2. **Make the script executable:**

   ```sh
   chmod +x k8s-tmux-by-label.sh
   chmod +x k8s-tmux-by-namespace.sh
   ```

---

## 🛠 Usage

Run the script with the desired Kubernetes namespace:

```sh
./k8s-tmux.sh <namespace>
```

Example:

```sh
./k8s-tmux.sh web
```

This will:

- Open a **new tmux session** named `k8s-web`
- Execute into all pods within the `web` namespace
- Tile all tmux panes for better visibility
- Enable **synchronized input** across all panes

---

## 📌 Example Deployment File

To use this script with a Kubernetes deployment, apply the following configuration:

```
kubectl apply -f nodejs-deployment.yaml
```


Then, use the script to connect to the running pods:

```sh
./k8s-tmux.sh web
```

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
| **Select pane**         | `Ctrl + q + <number>`                               |
| **Enable sync input**   | `Ctrl + B`, then `:` → `setw synchronize-panes on`  |

---

## 🔥 Example Workflow

1. Deploy example k8s web with two pods
   ```sh
   kubectl apply -f nodejs-deployment.yaml
   ```
   It will deploy 3 example nodejs pods in namespace `web`. Two of them have label `part=first` and one of them has label `part=second`.

### Multi-Pod Exec with tmux for all pods in namespace

1. Run the command:
   ```sh
   ./k8s-tmux-by-namespace.sh web
   ```
   To start tmux sync session for all pods in namespace `web`
2. Interact with the pods inside **tmux**.
3. Detach from tmux when needed (`Ctrl + B`, then `D`) or (`Ctrl + d`).
4. Exit all pods (`Ctrl + d` or `exit` in each pane) to **auto-close the session**.
5. Delete the deployment
   ```sh
   kubectl delete deployment my-app
   ```

### Multi-Pod Exec with tmux for all pods with particular label

1. Run the command:
   ```sh
   ./k8s-tmux-by-label.sh part=first
   ```
   To start tmux sync session for all pods in namespace `web`
3. Interact with the pods inside **tmux**.
4. Detach from tmux when needed (`Ctrl + B`, then `D`) or (`Ctrl + d`).
5. Exit all pods (`Ctrl + d` or `exit` in each pane) to **auto-close the session**.
6. Delete the deployment
   ```sh
   kubectl delete deployment my-app
   ```
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

### 3️⃣ "Sessions should be nested with care, unset \$TMUX to force"

✅ You're trying to run `tmux` **inside another tmux session**.

- **Option 1:** Detach first (`Ctrl + B`, then `D`) and rerun the script.
- **Option 2:** Run:
  ```sh
  unset TMUX && ./k8s-tmux.sh web
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

🚀 Happy Kubernetes managing with tmux! 🎉

