#!/bin/bash

# Script to move documentation files to lib/docs directory

echo "=========================================="
echo "Finalizing Phase 2 Documentation Setup"
echo "=========================================="
echo ""

# Create lib/docs directory
echo "Creating lib/docs directory..."
mkdir -p lib/docs

# Move files
echo "Moving documentation files..."
mv -f FIREBASE_SETUP.md lib/docs/ 2>/dev/null && echo "✓ Moved FIREBASE_SETUP.md"
mv -f REVENUECAT_SETUP.md lib/docs/ 2>/dev/null && echo "✓ Moved REVENUECAT_SETUP.md"  
mv -f ADMOB_SETUP.md lib/docs/ 2>/dev/null && echo "✓ Moved ADMOB_SETUP.md"
mv -f AFFILIATE_SETUP.md lib/docs/ 2>/dev/null && echo "✓ Moved AFFILIATE_SETUP.md"

# Clean up helper scripts
rm -f move_docs.py create_docs.py finalize_docs.py setup_docs.py setup_docs.bat move_docs.sh 2>/dev/null

# Verify
echo ""
echo "=========================================="
echo "Verification"
echo "=========================================="
if [ -d "lib/docs" ]; then
    echo "✓ lib/docs directory exists"
    echo ""
    echo "Files in lib/docs:"
    ls -lh lib/docs/ | grep -E "\.md$" && echo "" || echo "Warning: No .md files found"
    
    count=$(find lib/docs -name "*.md" -type f | wc -l)
    echo "✓ Total files: $count"
    
    size=$(du -sh lib/docs 2>/dev/null | awk '{print $1}')
    echo "✓ Total size: $size"
    
    echo ""
    echo "=========================================="
    echo "✓ Setup Complete!"
    echo "=========================================="
else
    echo "✗ lib/docs directory was not created"
    exit 1
fi
