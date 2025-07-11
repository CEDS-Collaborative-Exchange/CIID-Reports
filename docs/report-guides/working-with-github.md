---
icon: github
---

# Working with GitHub

### **What is GitHub?**

GitHub is a platform for version control and collaboration. It allows multiple people to work on projects simultaneously, track changes, and manage contributions. Projects on GitHub are stored in repositories (repos), which can include code, documentation, and other files.

#### **Common GitHub Actions**

* **Clone:** Download a copy of the repository to your local machine.
* **Fork:** Create your own copy of the repository on your GitHub account to make changes independently.
* **Pull Request:** Propose changes to the main project by sending your edits for review.
* **Issues:** A place to track bugs, enhancements, or any other project tasks.
* **Commits:** Changes made to files in the repository, tracked with a commit message.

***

### **1. How to Access Repositories**

There are two main ways to access files and repositories on GitHub:

#### **Option A: Using the GitHub Web Interface**

1. **Navigate to the Repository**: Browse to the repository's URL.

{% @github-files/github-code-block url="https://github.com/CEDS-Collaborative-Exchange/CIID-Reports" %}

2. **Download Files**: You can download individual files by clicking on them, then selecting the "Raw" option and saving the content.
3. **Download the Entire Repo**: Use the **Code** button at the top of the repo page to download the repository as a ZIP file.

#### **Option B: Using Git with a Terminal**

1. **Install Git**: Download and install Git from [here](https://git-scm.com/).
2. **Clone a Repository**:
   * Open a terminal or command prompt.
   * Navigate to the folder where you want to store the repository.
   *   Use the following command to clone the repository:

       ```bash
       bashCopy codegit clone <repository-url>
       ```
3. **Open in Your Editor**: You can now open the repository in any code editor (e.g., VSCode).

***

### **2. Making Changes and Submitting Contributions**

#### **A. Fork and Clone the Repository**

To make changes to the repository, you’ll typically:

1. **Fork the Repository**: This creates your own copy of the repo that is located under your GitHub account.
2.  **Clone Your Fork**: Download **your** fork to your local machine using the `git clone` command.

    ```bash
    bashCopy codegit clone <your-fork-url>
    ```

#### **B. Make Changes Locally**

1. **Create a Branch**:
   *   Before making any changes, create a new branch to isolate your work:

       ```bash
       bashCopy codegit checkout -b your-branch-name
       ```
2. **Make Edits**: Edit the files as needed.
3. **Commit Changes**:
   *   Once you're done with your edits, commit your changes with a message that describes what you’ve done:

       ```bash
       bashCopy codegit add .
       git commit -m "Your commit message"
       ```
4. **Push Your Branch**:
   *   Push the changes to your fork on GitHub:

       ```bash
       bashCopy codegit push origin your-branch-name
       ```

#### **C. Submit a Pull Request**

1. **Create a Pull Request**: Go back to GitHub, and you'll see a notification to create a pull request from your branch.
2. **Describe Your Changes**: Provide a meaningful description of what you've changed or added.
3. **Submit the Pull Request**: Click **Create Pull Request** to send your changes to be reviewed and potentially merged into the main project.

***

### **3. Reporting Issues and Asking for Help**

#### **Opening an Issue**

If you encounter bugs or have suggestions for improvements, you can report them via **Issues**:

1. **Go to the Issues Tab**: Navigate to the Issues tab in the repository.
2. **Click 'New Issue'**: Provide a clear title and description of the issue.
3. **Submit**: Once done, click the **Submit** button.

#### **Contributing to Discussions**

You can also participate in discussions about the project or review other people’s pull requests by leaving comments and feedback on issues and pull requests.

***

### **4. Common Git Commands Reference**

Here are a few common Git commands you might find useful:

* **Clone a repository**: `git clone <repo-url>`
* **Check repo status**: `git status`
* **Create a new branch**: `git checkout -b <branch-name>`
* **Add changes**: `git add .`
* **Commit changes**: `git commit -m "Your message"`
* **Push changes**: `git push origin <branch-name>`
* **Pull latest changes from the original repo**: `git pull origin main`
* **Merge branches**: `git merge <branch-name>`

***

### **5. Working with GitHub in VSCode**

For those using Visual Studio Code, GitHub integration is built-in:

1. **Clone the Repository**: Use the `git clone` command to download the repo locally or clone directly from VSCode by opening the Command Palette (`Ctrl+Shift+P`) and typing "Git: Clone."
2. **Commit Changes**: After making edits, you can commit your changes directly within VSCode. Use the **Source Control** tab (`Ctrl+Shift+G`).
3. **Push to GitHub**: Push your commits to GitHub by clicking the **Sync Changes** icon.

***

### **Further Learning Resources**

* [GitHub Docs](https://docs.github.com/)
* [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
* [Git for Beginners](https://guides.github.com/introduction/git-handbook/)
