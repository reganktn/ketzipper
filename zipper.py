import os
import sys
import zipfile
import tkinter as tk
from tkinter import filedialog


def create_archive(files_to_add):
    # Ask the user for the save location
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

    # Create the archive
    with zipfile.ZipFile(save_path, 'w', zipfile.ZIP_DEFLATED) as archive:
        for file_or_dir in files_to_add:
            if os.path.isdir(file_or_dir):  # If it's a directory, add all files inside it
                for root, _, files in os.walk(file_or_dir):
                    for file in files:
                        file_path = os.path.join(root, file)
                        archive.write(file_path, os.path.relpath(file_path, start=file_or_dir))
            else:  # If it's a file, just add it directly
                archive.write(file_or_dir, os.path.basename(file_or_dir))
    
    print(f"Archive created: {save_path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python zipper.py <file_or_directory_1> [<file_or_directory_2> ...]")
        sys.exit(1)
    
    files_to_add = sys.argv[1:]  # Get the list of files/directories from command line arguments
    create_archive(files_to_add)
