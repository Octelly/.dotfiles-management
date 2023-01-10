import apply_dpi from require "beautiful.xresources"

font = (size=14, style="Regular", name="Noto Sans") ->
	"#{name} #{style}
#{if style != nil then " "}
#{apply_dpi(size)}"

-- font presets based on:
-- https://m3.material.io/styles/typography/type-scale-tokens#40fc37f8-3269-4aa3-9f28-c6113079ac5d
{
	display: {
		large:  font 57,
		medium: font 45,
		small:  font 36,
	},
	headline: {
		large:  font 32,
		medium: font 28,
		small:  font 24,
	},
	title: {
		large:  font 22,
		medium: font 16, "Medium",
		small:  font 14, "Medium",
	},
	label: {
		large:  font 14, "Medium",
		medium: font 12, "Medium",
		small:  font 11, "Medium",
	},
	body: {
		large:  font 16, "Medium",
		medium: font 14,
		small:  font 12,
	},
}
