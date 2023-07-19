# shellcheck shell=bash

task.init() {
	pnpm install
}

# shellcheck disable=SC2034
task.svg() {
	local decoration_color='#ffdeeb'
	local ecosystem_color='#e5dbff'
	local platform_color='#ffe8cc'

	inkscape -w 512 -h 512 ./assets/package.svg -o ./assets/package.png
	for type in decoration ecosystem platform; do
		for dir in ./"$type"-packs/*; do
			local color_var="${type}_color"
			local -n color="$color_var"
			mkdir -p "$dir/assets"
			convert ./assets/package.png -background "$color" -flatten -alpha off "$dir/assets/icon.png"
		done
	done
}

task.publish() {
	local pack=$1
	cd "$pack"

	vsce publish
	ovsx publish --pat "$(<'../../.env-ovsx')"
}
