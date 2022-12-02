
lines = $("#xialiwei_test_input").val()
lines_base = lines.split("\n")
flag = false
lines_data = []

num = 0
max_num = lines_base.length-1

#for line,num in lines_base
translate_line = (num,callback=null)->
    if num>max_num
        return
    # if num == 20
    #     break
    a=lines_base[num]
    if a.indexOf(" --> ")>-1
        flag = true
        num = num + 1
        return translate_line(num)
        
    if not flag
        num = num + 1
        return translate_line(num)
    if flag
        if a.length==0
            flog=false
            num = num + 1
            return translate_line(num)
    do(line,num,lines_data)->
        a_list = a.split("<c>")
        a_list_result = []
        for a_list_item,key in a_list
            content = a_list_item
            content_result = ""
            do (content,content_result,key,num)->
                $.ajax
                    url: "https://www.hotpoor.com/api/baiduai/translate"
                    data:
                        content: content
                        lan: "en"
                        to: "zh"
                    async:false
                    dataType: 'json'
                    type: 'POST'
                    success: (data) ->
                        console.log data
                        if data.result?
                            for result_i in data.result
                                content_results = result_i["trans_result"]
                                for result in content_results
                                    content_result = "#{content_result}#{result["dst"]}"
                                a_list_result[key]=content_result
                    error: (data)->
                        console.log data
        lines_data.push([num,a_list_result])
        num = num + 1
        translate_line(num)

translate_line(0)

for i in lines_data
    if i[1].length>1
        lines_base[i[0]]=i[1].join("<c>")
    else if i[1].length==1
        lines_base[i[0]]=i[1][0]

       