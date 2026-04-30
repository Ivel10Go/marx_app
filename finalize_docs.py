#!/usr/bin/env python3
"""
Create lib/docs directory with all documentation files for Phase 2 monetization setup.
This script creates the directory structure and files with complete content.
"""

import os
import sys

def create_docs_directory():
    """Create the lib/docs directory structure"""
    lib_path = os.path.join("lib", "docs")
    os.makedirs(lib_path, exist_ok=True)
    print(f"✓ Created directory: {lib_path}")
    return lib_path

def create_documentation_files(lib_docs_path):
    """Create all documentation files in lib/docs"""
    
    # Read files from root directory
    files_to_copy = {
        "FIREBASE_SETUP.md": "FIREBASE_SETUP.md",
        "REVENUECAT_SETUP.md": "REVENUECAT_SETUP.md",
        "ADMOB_SETUP.md": "ADMOB_SETUP.md",
        "AFFILIATE_SETUP.md": "AFFILIATE_SETUP.md"
    }
    
    created_files = []
    
    for src_filename, dst_filename in files_to_copy.items():
        src_path = src_filename
        dst_path = os.path.join(lib_docs_path, dst_filename)
        
        try:
            if os.path.exists(src_path):
                # Read source
                with open(src_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Write to destination
                with open(dst_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                size = os.path.getsize(dst_path)
                print(f"✓ Created {dst_filename} ({size} bytes)")
                created_files.append(dst_filename)
            else:
                print(f"✗ Source file not found: {src_path}")
        except Exception as e:
            print(f"✗ Error creating {dst_filename}: {e}")
    
    return created_files

def verify_setup(lib_docs_path):
    """Verify that all files were created correctly"""
    print("\n" + "="*60)
    print("VERIFICATION")
    print("="*60)
    
    if not os.path.exists(lib_docs_path):
        print(f"✗ ERROR: Directory {lib_docs_path} does not exist")
        return False
    
    expected_files = [
        "FIREBASE_SETUP.md",
        "REVENUECAT_SETUP.md",
        "ADMOB_SETUP.md",
        "AFFILIATE_SETUP.md"
    ]
    
    created_files = os.listdir(lib_docs_path)
    total_size = 0
    
    print(f"\nFiles in {lib_docs_path}:")
    for filename in expected_files:
        full_path = os.path.join(lib_docs_path, filename)
        if os.path.exists(full_path):
            size = os.path.getsize(full_path)
            total_size += size
            print(f"  ✓ {filename} ({size} bytes)")
        else:
            print(f"  ✗ {filename} (MISSING)")
            return False
    
    print(f"\nTotal files: {len(created_files)}")
    print(f"Total size: {total_size} bytes ({total_size / 1024:.2f} KB)")
    print("\n✓ Setup completed successfully!")
    return True

def main():
    """Main execution function"""
    print("="*60)
    print("Documentation Setup for Phase 2 Monetization")
    print("="*60 + "\n")
    
    try:
        # Create directory
        lib_docs_path = create_docs_directory()
        
        # Create files
        print("\nCreating documentation files...")
        created = create_documentation_files(lib_docs_path)
        
        # Verify
        success = verify_setup(lib_docs_path)
        
        if success:
            print("\n" + "="*60)
            print("Setup Status: SUCCESS ✓")
            print("="*60)
            print("\nAll documentation files have been created in lib/docs/")
            print("Ready for Phase 2 monetization setup!")
            return 0
        else:
            print("\nSetup Status: FAILED ✗")
            return 1
            
    except Exception as e:
        print(f"\n✗ Fatal error: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
