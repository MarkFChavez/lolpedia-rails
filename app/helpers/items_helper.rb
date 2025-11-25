module ItemsHelper
  # Parse League of Legends item description tags into readable HTML
  def parse_item_description(description)
    return "" if description.blank?

    # Replace custom LoL tags with styled HTML spans
    parsed = description
      .gsub(/<mainText>/, '')
      .gsub(/<\/mainText>/, '')
      .gsub(/<stats>/, '<div class="text-lol-teal-400 font-semibold mb-2">')
      .gsub(/<\/stats>/, '</div>')
      .gsub(/<attention>/, '<span class="text-red-400 font-semibold">')
      .gsub(/<\/attention>/, '</span>')
      .gsub(/<passive>/, '<span class="text-lol-gold-400 font-semibold">')
      .gsub(/<\/passive>/, '</span>')
      .gsub(/<active>/, '<span class="text-blue-400 font-semibold">')
      .gsub(/<\/active>/, '</span>')
      .gsub(/<rarityMythic>/, '<span class="text-orange-500 font-bold">')
      .gsub(/<\/rarityMythic>/, '</span>')
      .gsub(/<rarityLegendary>/, '<span class="text-purple-500 font-bold">')
      .gsub(/<\/rarityLegendary>/, '</span>')
      .gsub(/<magicDamage>/, '<span class="text-blue-400">')
      .gsub(/<\/magicDamage>/, '</span>')
      .gsub(/<physicalDamage>/, '<span class="text-orange-400">')
      .gsub(/<\/physicalDamage>/, '</span>')
      .gsub(/<trueDamage>/, '<span class="text-white font-semibold">')
      .gsub(/<\/trueDamage>/, '</span>')
      .gsub(/<healing>/, '<span class="text-green-400">')
      .gsub(/<\/healing>/, '</span>')
      .gsub(/<shield>/, '<span class="text-gray-300">')
      .gsub(/<\/shield>/, '</span>')
      .gsub(/<scaleAP>/, '<span class="text-blue-300">')
      .gsub(/<\/scaleAP>/, '</span>')
      .gsub(/<scaleAD>/, '<span class="text-orange-300">')
      .gsub(/<\/scaleAD>/, '</span>')
      .gsub(/<scaleMana>/, '<span class="text-blue-300">')
      .gsub(/<\/scaleMana>/, '</span>')
      .gsub(/<scaleHealth>/, '<span class="text-green-400">')
      .gsub(/<\/scaleHealth>/, '</span>')
      .gsub(/<speed>/, '<span class="text-yellow-400">')
      .gsub(/<\/speed>/, '</span>')
      .gsub(/<status>/, '<span class="text-purple-400">')
      .gsub(/<\/status>/, '</span>')
      .gsub(/<keywordStealth>/, '<span class="text-gray-400 italic">')
      .gsub(/<\/keywordStealth>/, '</span>')
      .gsub(/<keywordMajor>/, '<span class="text-lol-gold-400 font-bold">')
      .gsub(/<\/keywordMajor>/, '</span>')
      .gsub(/<rules>/, '<div class="text-gray-400 text-sm italic mt-2">')
      .gsub(/<\/rules>/, '</div>')
      .gsub(/<li>/, '<br>• ')
      .gsub(/<br>/, '<br/>')

    # Remove any remaining unknown tags to prevent rendering issues
    parsed = parsed.gsub(/<\/?[a-zA-Z]+>/, '')

    parsed.html_safe
  end
end
