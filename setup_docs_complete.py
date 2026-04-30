#!/usr/bin/env python3
import os
import sys

# Get the current directory
cwd = os.getcwd()
print(f"Current directory: {cwd}")

# Create lib/docs directory
docs_dir = os.path.join(cwd, "lib", "docs")
os.makedirs(docs_dir, exist_ok=True)
print(f"Created directory: {docs_dir}")

# List contents
if os.path.exists(docs_dir):
    print(f"Contents of {docs_dir}: {os.listdir(docs_dir)}")
else:
    print(f"Failed to create {docs_dir}")

# List files in root that need to be moved
root_files = [
    "FIREBASE_SETUP.md",
    "REVENUECAT_SETUP.md",
    "ADMOB_SETUP.md",
    "AFFILIATE_SETUP.md"
]

print("\nFiles to move:")
for f in root_files:
    path = os.path.join(cwd, f)
    if os.path.exists(path):
        print(f"  ✓ {f} exists")
        # Move file
        dst = os.path.join(docs_dir, f)
        with open(path, 'r', encoding='utf-8') as src_file:
            content = src_file.read()
        with open(dst, 'w', encoding='utf-8') as dst_file:
            dst_file.write(content)
        print(f"    → Copied to {os.path.relpath(dst, cwd)}")
    else:
        print(f"  ✗ {f} not found")

print("\nFinal verification:")
if os.path.exists(docs_dir):
    contents = os.listdir(docs_dir)
    print(f"Files in {os.path.relpath(docs_dir, cwd)}: {contents}")
    print(f"Total files: {len(contents)}")
