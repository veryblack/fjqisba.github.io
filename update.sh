rm -f -r docs
hugo -d docs
git add .
git status
git commit -m "content update"
git push