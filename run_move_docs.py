#!/usr/bin/env python3
import os
import shutil
from pathlib import Path

# Get the project root
root = Path(os.getcwd())
print(f"Working in: {root}")

# Create lib/docs directory
docs_dir = root / "lib" / "docs"
docs_dir.mkdir(parents=True, exist_ok=True)
print(f"✓ Created/verified lib/docs directory at {docs_dir}")

# Files to move
files_to_move = [
    "FIREBASE_SETUP.md",
    "REVENUECAT_SETUP.md",
    "ADMOB_SETUP.md",
    "AFFILIATE_SETUP.md"
]

# Move files
print("\n=== Moving files ===")
for file in files_to_move:
    src = root / file
    dst = docs_dir / file
    if src.exists():
        shutil.move(str(src), str(dst))
        print(f"✓ Moved: {file}")
    else:
        print(f"✗ NOT FOUND: {file}")

# List files in lib/docs
print("\n=== Verification: Files in lib/docs ===")
if docs_dir.exists():
    files = list(docs_dir.glob("*"))
    if files:
        for file in sorted(files):
            print(f"  - {file.name}")
    else:
        print("  (no files)")
else:
    print("  (directory not found)")

# Clean up temporary scripts
temp_scripts = [
    "move_docs.py",
    "create_docs.py",
    "finalize_docs.py",
    "setup_docs.py",
    "setup_docs.bat",
    "finalize_setup.sh",
    "do_docs_move.py"  # Our own script
]

print("\n=== Cleaning up temporary scripts ===")
for script in temp_scripts:
    script_path = root / script
    if script_path.exists():
        script_path.unlink()
        print(f"✓ Removed: {script}")

print("\n✓ Documentation setup complete!")
