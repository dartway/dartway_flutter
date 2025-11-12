# Contributing to DartWay

Thank you for your interest in contributing to **DartWay**!  
We appreciate all improvements — from small fixes to major features.

---

## 🧩 How to contribute

1. **Fork** the repository and create a feature branch.  
2. Make your changes and ensure that tests and formatting pass.  
3. Commit with a **Signed-off-by** line (see below).  
4. Open a Pull Request with a clear description of what you’ve done.

---

## ✅ Developer Certificate of Origin (DCO)

By adding a Signed-off-by line to your commit, you certify that:

```
Developer Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I have the right to submit it under the open source license indicated in the file; or

(b) The contribution is based upon previous work that, to the best of my knowledge, is covered under an appropriate open source license and I have the right under that license to submit that work with modifications, under the same license; or

(c) The contribution was provided directly to me by some other person who certified (a), (b), or (c), and I have not modified it.

(d) I understand and agree that this project and the contribution are public and that a record of the contribution (including all personal information I submit with it, such as my sign-off) is maintained indefinitely and may be redistributed consistent with this project or the open source license involved.
```

To sign your commits, use:

```bash
git commit -s -m "your message"
```

This adds a line like:

```
Signed-off-by: Your Name <your@email.com>
```

All commits in pull requests **must include** this sign-off line.

---

### ❗ If the DCO check fails

If the GitHub Action reports something like:

```
The sign-off is missing
```

It means one or more commits in your branch are missing the `Signed-off-by` line.  
Here’s how to fix it:

1. Re-sign the last *N* commits (replace `3` with the number shown in the error):
   ```bash
   git rebase HEAD~3 --signoff
   ```
2. Push the updated commits:
   ```bash
   git push --force-with-lease origin <your-branch-name>
   ```
3. The DCO check will rerun automatically and should pass once commits are properly signed.

💡 **Tip:** You can create a shortcut for signed commits:
```bash
git config --global alias.c "commit -s -m"
```
Now just run:
```bash
git c "Add feature X"
```

---

## 🔒 Licensing and third-party code

* All contributions are licensed under the same **Apache License 2.0** as the project.  
* If you include third-party code, you must:
  * Confirm it’s compatible with Apache-2.0.  
  * Include the original copyright notice and license.  
  * Mention the source in your PR description.

---

## 🧠 Need help?

If you have any questions or want to discuss ideas before implementing them, feel free to open a **GitHub Discussion** or contact the maintainers.

Thanks for helping make DartWay better!
