rm -f -r docs
hugo -b "https://fjqisba.github.io" -d docs
git add .
git status
git commit -m "content update"
git push