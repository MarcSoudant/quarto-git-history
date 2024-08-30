-- run git and read its output
local function git(command, readType)
    readType = readType or '*all'
    local p = io.popen("git " .. command)
    local output = ""
    if p ~= nil then
      output = p:read(readType)
      p:close()
    end
    return output
end

-- return a table containing shortcode definitions
-- defining shortcodes this way allows us to create helper 
-- functions that are not themselves considered shortcodes 
return {
    ["git-history"] = function(args, kwargs)
        -- An example for future use (taken from quarto docs)...
        -- local cmdArgs = ""
        -- local short = pandoc.utils.stringify(kwargs["short"])
        -- if short == "true" then cmdArgs = cmdArgs .. "--short " end

        local header =  "| version | date | author | description |\n"
        local divider = "|:--------|:-----|:-------|:------------|\n"

        -- tried this command but didn't give satisfaction
        -- git for-each-ref "*[0-9].[0-9]" --sort=committerdate --shell 
        -- --format=\"echo '|' %(refname:short) '|' %(committerdate:short) '|' %(authorname) '|'; 
        --     git log 
        --         $($(git tag -l '*[0-9].[0-9]' 
        --                 --sort=-creatordate ; echo '') | 
        --             grep -A 1 %(refname:short) | tail -n 1)
        --         %(refname:short) 
        --         --reverse --no-merges --exclude='auto:' 
        --         --pretty=format:'- %s ';
        --     echo '|';" refs/tags

        local description = ''

        -- loop along tags
        local tagslist = io.popen('git tag -l "*[0-9].[0-9]" --sort=committerdate')
        local prevtag = nil
        if tagslist ~= nil then
            for tag in tagslist:lines() do
                -- get the commit info linked to the tag
                description = description .. git('tag -l ' .. tag .. ' --format="| **%(refname:short)** | *%(committerdate:short)* | %(authorname) | ', '*l')
                -- previous tag ?
                if prevtag ~= nil then
                    prevtag = prevtag .. '..'
                else
                    prevtag = ''
                end
                -- loop along commmits between current tag and previous
                local commits = io.popen('git log ' .. prevtag .. tag .. ' --reverse --no-merges --invert-grep --grep="^auto:.*" --pretty=format:"- %s"')
                if commits ~= nil then
                    for commit in commits:lines() do
                        description = description .. commit .. "<br>"
                    end
                    commits:close()
                end
                --en of the line
                description = description .. '|\n'
                --save tag to previous for next loop
                prevtag = tag
            end
            tagslist:close()
        end

        -- return as string
        if description ~= '' then
            return pandoc.read(header .. divider .. description ).blocks
        else
            return pandoc.Null()
        end
    end
}
