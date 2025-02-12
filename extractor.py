import os
import zipfile
import rarfile
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import sys
import threading
import subprocess

def extract_archive(archive_path):
    """Extracts ZIP or RAR files to a user-specified location using native system commands for maximum speed."""
    if not os.path.exists(archive_path):
        messagebox.showerror("Error", "File not found!")
        return
    
    # Set UnRAR tool location
    rarfile.UNRAR_TOOL = "C:\\KetZipper\\UnRar.exe"
    
    # Ask for extraction destination
    root = tk.Tk()
    root.withdraw()  # Hide main window
    extract_to = filedialog.askdirectory(title="Select Extraction Folder")
    if not extract_to:
        messagebox.showwarning("Warning", "No extraction folder selected.")
        return
    
    # Create progress window
    progress_window = tk.Toplevel()
    progress_window.title("Extracting")
    progress_window.geometry("400x120")
    label = tk.Label(progress_window, text="Extracting... Please wait.")
    label.pack(pady=10)
    
    progress_bar = ttk.Progressbar(progress_window, length=300, mode='indeterminate')
    progress_bar.pack(pady=10)
    progress_bar.start()
    
    def extract():
        try:
            if archive_path.endswith(".zip"):
                subprocess.run(["powershell", "Expand-Archive", "-Path", archive_path, "-DestinationPath", extract_to, "-Force"], check=True)
            
            elif archive_path.endswith(".rar"):
                subprocess.run(["C:\\ZipExtractor\\UnRar.exe", "x", archive_path, extract_to], check=True)
            
            else:
                messagebox.showerror("Error", "Unsupported file format!")
                progress_window.destroy()
                return
            
            progress_window.destroy()
            messagebox.showinfo("Success", "Extraction completed successfully!")
            subprocess.run(["explorer", extract_to], check=True)
        except Exception as e:
            progress_window.destroy()
            messagebox.showerror("Error", f"Extraction failed: {e}")
    
    threading.Thread(target=extract, daemon=True).start()
    root.mainloop()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        extract_archive(sys.argv[1])
    else:
        messagebox.showwarning("Warning", "Drag and drop a ZIP or RAR file onto this script or set it up as a context menu option.")
