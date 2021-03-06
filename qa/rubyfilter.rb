
# the value of `params` is the value of the hash passed to `script_params`
# in the logstash configuration
def register(params)
  @p_category = params["category"]
end

# the filter method receives an event and must return a list of events.
# Dropping an event means not including it in the return array,
# while creating new ones only requires you to add a new instance of
# LogStash::Event to the returned array
def filter(event)

  #Category
  category = event.get("category")
  if category.nil?
    category = ""
  end

  new_category = fn_make_cate_all(category, 0)  
  event.set("category", new_category)

  service_gubun = event.get("service_gubun")

  new_cat1 = fn_make_cate_all(category, 2)  
  event.set("cat1", new_cat1)
  
  new_cat2 = fn_make_cate_all(category, 4)  
  event.set("cat2", new_cat2)
  
  new_cat3 = fn_make_cate_all(category, 6)  
  event.set("cat3", new_cat3)
 
  new_cat4 = fn_make_cate_all(category, 8)  
  event.set("cat4", new_cat4)

  new_cg = ""
  if service_gubun == "1"
    new_cg = new_cat2  
  else
    new_cg = new_cat1  
  end 
  event.set("cg", new_cg)

  #Model Factory
  #deplecated : ES에서 Model-Factory 전용 Tokenizer 사용

  if service_gubun == "1"
    #2018.06.14 변경. model_factory를 modelnm2로 부터 생성.
=begin
    modelnm = event.get("modelnm")
    factory = event.get("factory")
    if modelnm.nil?
      modelnm = "";
    end
    if factory.nil?
      factory = ""
    end
    model_factory = factory_all(modelnm+" "+factory)
=end
    modelnm2 = event.get("modelnm2")
    if modelnm2.nil?
      modelnm2 = "";
    end

    model_factory = factory_all(modelnm2)

    event.set("model_factory", model_factory)
  end
  
  return [event]

end

#카테고리를 대/중/소 분류 형태의 문자열로 변환
def fn_cate_all(category)
  arr_cate = []
  arr_cate << category[0,2] << category[0,4] << category[0,6] << category[0,8]
  return arr_cate
end

# 카테고리에서 해당 사이즈에 해당하는 분류로 반환
def fn_cate_sub(category, size)
  cate_sub = category[0, size]
  if cate_sub.length != size
    cate_sub = ""
  end
  cate_sub
end

#여러 카테고리 문자열에서 대/중/소 분류 형태로 문자열로 변환
def fn_make_cate_all(param, size)

  begin

    # 공백문자를 구분자로 배열로 분리
    params = param.split(" ")
    cate_arr = []

    #카테고리를 대/중/소 분류 형태의 문자열로 변환
    if size == 0
      params.each{|x| cate_arr = cate_arr | fn_cate_all(x) }
    else
      params.each{|x| cate_arr << fn_cate_sub(x, size) }
    end

    #중복제거
    cate_arr.uniq!

    #하나의 스트링으로 통합
    cate_str_all = cate_arr.join(" ")

  # exception 발생시.
  rescue
    cate_str_all = "-"
  end

  cate_str_all 

end

=begin
def factory_all(mf)

  #remove [-]
  mf = mf.sub("-","")

  pattern = "[a-zA-Z|0-9]+[-|.|_|a-zA-Z|0-9]*[a-zA-Z|0-9]+"
  mfs = mf.scan(/#{pattern}/)
  if !mfs.nil?
    mfs.uniq!
    mfs = mfs.join(" ")
  end
  mfs

end
=end

def factory_all(mf)

  begin

    #소문자화
    mf = mf.downcase

    #remove [-][/][_]
    mf = mf.gsub("-","")
    mf = mf.gsub("/"," ")
    mf = mf.gsub("_","")

    pattern = "[a-zA-Z|0-9]+[-|.|_|a-zA-Z|0-9]*[a-zA-Z|0-9]+"
    mfs = mf.scan(/#{pattern}/)
    arrmf = []
    if !mfs.nil?
      #mfs.uniq!
      #mfs = mfs.join(" ")

      mfs.each do |mf|
        if !mf.nil?
          #puts "mf : "+mf
          for i in 1..mf.length
            nf_ngram = ngram(mf, i)
            arrmf << nf_ngram
          end
        end
      end

    end
    #mfs

    arrmf.uniq!
    mf_all = arrmf.join(" ")

  # exception 발생시.
  rescue
    mf_all = "-"
  end

  mf_all

end

def ngram(str, n)

  strSplit = str.split(//)
  consArr = strSplit.each_cons(n).to_a
  ngArr = []
  
  consArr.each do |cons|
    #puts "->  #{cons}"
    ngArr.push(cons.join(""))
  end

  #puts ngArr
  return ngArr
end
