import os
import sys
import zipfile
import tkinter as tk
from tkinter import simpledialog
from tkinter import filedialog


def create_archive(target_path):
    root = tk.Tk()
    root.withdraw()
    
    save_path = filedialog.asksaveasfilename(
        defaultextension=".zip",
        filetypes=[("ZIP files", "*.zip"), ("RAR files", "*.rar")],
        title="Save Archive As"
    )
    
    if not save_path:
        print("Operation cancelled.")
        return
    
    with zipfile.ZipFile(save_path, 'w', zipfile.ZIP_DEFLATED) as archive:
        if os.path.isdir(target_path):
            for root, _, files in os.walk(target_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    archive.write(file_path, os.path.relpath(file_path, start=target_path))
        else:
            archive.write(target_path, os.path.basename(target_path))
    
    print(f"Archive created: {save_path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python zipper.py <target_path>")
        sys.exit(1)
    
    target_path = sys.argv[1]
    create_archive(target_path)
