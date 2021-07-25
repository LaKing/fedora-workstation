git add .

git commit --author="$USER <$USER@$HOSTNAME>" -m "$(cat /srv/codepad-project/version)"

git push