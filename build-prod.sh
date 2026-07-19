echo $(pwd)
rm -rf .output
mkdir -p .output/dist

cp redirects .output/dist/_redirects || exit 1

#bash -cx "cd 77;
#rm -rf .nuxt .output node-modules;
#pnpm i;
#pnpm exec nuxt generate;"

#cp -r 77/.output/public .output/dist/77

# this is really horrible sedding the generated JS files but the map-app package is already generated with the hard url...
bash -cx "cd 76 &&
rm -rf .nuxt .output node-modules &&
yarn install --immutable &&
sed 's|https://www.komabasai.net||' 'node_modules/@komaba-festival-committee/map-app/dist/map-app.es.js' | 
    sed 's|https://api.komabasai.net/76|/76/api|' > 'node_modules/@komaba-festival-committee/map-app/dist/map-app.es.js.tmp' &&
mv 'node_modules/@komaba-festival-committee/map-app/dist/map-app.es.js.tmp' 'node_modules/@komaba-festival-committee/map-app/dist/map-app.es.js' &&
sed 's|https://www.komabasai.net||' 'node_modules/@komaba-festival-committee/map-app/dist/map-app.umd.js' | 
    sed 's|https://api.komabasai.net/76|/76/api|' > 'node_modules/@komaba-festival-committee/map-app/dist/map-app.umd.js.tmp' &&
mv 'node_modules/@komaba-festival-committee/map-app/dist/map-app.umd.js.tmp' 'node_modules/@komaba-festival-committee/map-app/dist/map-app.umd.js' &&
yarn generate:production;" || exit 1

cp -r 76/.output/public .output/dist/76 || exit 1

echo "Copying KF76 geodata and map-style..."

bash -cx "mkdir -p .output/dist/76/geodata &&
cp 76mapapp/packages/map-geojson/geojson/*.geojson .output/dist/76/geodata &&
cd 76mapapp/packages/map-style &&
export VITE_GEODATA_BASE_URL=/76/geodata/ &&
export VITE_MAPSTYLE_URL=/76/map-style/ &&
export VITE_SPRITES_BASE_URL=/76/map-style/sprites/ &&
export VITE_PROJECT_API_BASE_URL=/76/api/project/ &&
pnpm install &&
pnpm generate
" || exit 1

bash -cx "mkdir -p .output/dist/76/map-style &&
cp -r 76mapapp/packages/map-style/dist/* .output/dist/76/map-style
" || exit 1

bash -cx "cd 75 &&
rm -rf .nuxt .output node-modules &&
yarn set version 4.6.0 &&
yarn install --immutable &&
export NUXT_PUBLIC_APP_MODE=production &&
yarn generate;" || exit 1

cp -r 75/.output/public .output/dist/75 || exit 1

bash -cx "cd 74 &&
rm -rf .nuxt .output node-modules &&
yarn set version 4.0.0-rc.44 &&
yarn install --immutable &&
yarn generate;" || exit 1

cp -r 74/.output/public .output/dist/74 || exit 1
