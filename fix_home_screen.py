import re

with open('lib/presentation/home/home_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the _HomeHeroCard class including all its content
content = re.sub(
    r'class _HomeHeroCard extends StatelessWidget \{\s*const _HomeHeroCard\(\);.*?\n\}',
    '',
    content,
    flags=re.DOTALL
)

# Clean up any extra blank lines left behind
content = re.sub(r'\n\n\n+', '\n\n', content)

with open('lib/presentation/home/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('Fixed!')
