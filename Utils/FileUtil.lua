function FindAllFile(dir, pattern, output)
    for entry in LFS.dir(dir) do
        if entry ~= '.' and entry ~= '..' then
            local path = dir .. "\\" .. entry
            local attr = LFS.attributes(path)
            assert(type(attr) == "table") --如果获取不到属性表则报错
            if attr.mode == "directory" then
                FindAllFile(path, pattern, output)
            elseif attr.mode == "file" then
                if string.find(entry, pattern) then
                    table.insert(output, path)
                end
            end
        end
    end
end
