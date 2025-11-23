module ApplicationHelper
  def current_patch_version
    @patch_version ||= Setting.find_by(key: "patch_version")&.value || "15.23.1"
  end

  def ddragon_url(path)
    "https://ddragon.leagueoflegends.com/cdn/#{current_patch_version}/#{path}"
  end
end
