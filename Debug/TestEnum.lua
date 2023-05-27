local enum = {
    a = 1,
    b = 2,
    c = 3,
    d = "test",
}
enum = Enum.New(enum)

print("访问枚举a", enum.a)
print("访问枚举e", enum.e)
print("访问枚举值test", enum["test"])

enum.a = 4

for key, value in enum:Pairs() do
    print("遍历枚举", key, value)
end
