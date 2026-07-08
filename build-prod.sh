echo $(pwd)
rm -rf .output
mkdir -p .output/dist

echo "/ /76/ 301" > .output/dist/_redirects || exit 1

#bash -cx "cd 77;
#rm -rf .nuxt .output node-modules;
#pnpm i;
#pnpm exec nuxt generate;"

#cp -r 77/.output/public .output/dist/77

bash -cx "cd 76 &&
rm -rf .nuxt .output node-modules &&
yarn install --immutable &&
yarn generate:production;" || exit 1

cp -r 76/.output/public .output/dist/76 || exit 1

echo "Copying KF76 geodata and map-style..."

bash -cx "mkdir -p .output/dist/76/geodata &&
cp 76mapapp/packages/map-geojson/geojson/*.geojson .output/dist/76/geodata &&
cd 76mapapp/packages/map-style &&
pnpm install &&
pnpm generate
" || exit 1

bash -cx "mkdir -p .output/dist/76/map-style &&
cp -r 76mapapp/packages/map-style/dist/* .output/dist/76/map-style
" || exit 1

bash -cx "cd 75 &&
rm -rf .nuxt .output node-modules &&
yarn install --immutable &&
export NUXT_PUBLIC_APP_MODE=production &&
yarn generate;" || exit 1

cp -r 75/.output/public .output/dist/75 || exit 1

bash -cx "cd 74 &&
rm -rf .nuxt .output node-modules &&
yarn install --immutable &&
yarn generate;" || exit 1

cp -r 74/.output/public .output/dist/74 || exit 1
