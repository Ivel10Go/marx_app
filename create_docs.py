#!/usr/bin/env python3
"""Create documentation files in lib/docs directory"""

import os

# Ensure lib/docs directory exists
lib_docs_path = os.path.join("lib", "docs")
os.makedirs(lib_docs_path, exist_ok=True)
print(f"✓ Created directory: {lib_docs_path}")

# Read source files from root and write to lib/docs
files_to_copy = [
    "FIREBASE_SETUP.md",
    "REVENUECAT_SETUP.md", 
    "ADMOB_SETUP.md",
    "AFFILIATE_SETUP.md"
]

for filename in files_to_copy:
    src_path = filename
    dst_path = os.path.join(lib_docs_path, filename)
    
    try:
        # Read source file
        if os.path.exists(src_path):
            with open(src_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Write to destination
            with open(dst_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"✓ Copied {filename} to {dst_path}")
        else:
            print(f"✗ Source file not found: {src_path}")
    except Exception as e:
        print(f"✗ Error copying {filename}: {e}")

# Verify
print("\n" + "="*50)
print("Verification:")
print("="*50)
if os.path.exists(lib_docs_path):
    files = os.listdir(lib_docs_path)
    print(f"Files in {lib_docs_path}:")
    for f in files:
        full_path = os.path.join(lib_docs_path, f)
        size = os.path.getsize(full_path)
        print(f"  - {f} ({size} bytes)")
    print(f"\nTotal: {len(files)} files created")
else:
    print(f"ERROR: Directory {lib_docs_path} does not exist")

print("\n✓ Documentation setup complete!")
