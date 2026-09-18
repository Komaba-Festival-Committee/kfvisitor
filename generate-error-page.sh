
bash -cx "cd 77;
git switch static-error-page;
git pull;
pnpm generate;
"

for i in .html .html.gz .html.br; do
  bash -cx "cp -v 77/dist/77/static-error/index${i} error/404${i}"
done
