_products = productList
_configImgs = configImgs

# jsonToCoffeeObj = (file)->
#   parsedJSON = JSON.parse(file)
#   return parsedJSON

# objectify = (json)->
#   obj = {}
#   for k,v of json
#     obj[k] = v
#   return obj

# construct this once
# list of js objects
# _products = jsonToCoffeeObj(productJSON)


getConfigImgList = ->
  return _configImgs

getConfigImgByIds = (ids)->
  src = (i.img for i in getConfigImgList() when arrayEqual(i.ids, ids))
  return src

arrayEqual = (a, b) ->
  a.length is b.length and a.every (elem, i) -> elem is b[i]

getProducts = ->
  return _products

getProductsSum = (ids,qty=1)->
  vals = (i.cost for i in getProducts() when i.id in ids)
  vals = _sumAll(vals)
  vals *= qty
  vals

getProductWeight = (ids)->
  vals = (i.weight for i in getProducts() when i.id in ids)
  vals = _sumAll(vals)
  vals

_sumAll = (vals)->
  vals.reduce (a,b) -> a + b

getProductsFiltered = (type="world",sortKey="order",sortReverse=false)->
  res = (i for i in getProducts() when i.id.split("_")[0] is type)
  if sortBy
    res.sort (a,b)->
      sortBy(sortKey,a,b,sortReverse)
  return res

getOrderSpecTxt = (orderItems)->
  specs = []
  for i in orderItems
    prod = getProductById(i)
    specs.push("<h4>"+prod.cartlabel+"</h4>")
    specs.push("<p class='LicenseSpecs-txt'>"+prod.cartSpecs+"</p>")
  html = specs.join(" ")
  return html

getConfigImageUrls = ->
  urls = (i.img for i in getConfigImgList()) 
  return urls

getImagesForOrder = (orderItems)->
  if orderItems.length > 1
    # it is pupil config item
    ids = (id for id in orderItems when id.split("_")[0] isnt 'license')  
    imgSrc = getConfigImgByIds(ids)    
    productImg = "<img src='#{ imgSrc }'class='Feature-image Feature-image--configEye'>"
    return productImg
  else
    # it is a simple product
    productImg = "<img src='#{ getProductById(orderItems[0]).img }' class='Feature-image Feature-image--configEye'>"
    return productImg


getProductById = (uid)->
  prod = i for i in getProducts() when i.id is uid
  return prod

sortBy = (key, a, b, r=false) ->
  # http://stackoverflow.com/questions/9796764/how-do-i-sort-an-array-with-coffeescript
  r = if r then 1 else -1
  return -1*r if a[key] > b[key]
  return +1*r if a[key] < b[key]
  return 0

# console.log getProductsFiltered('eye','cost',true)
# console.log getProductsSum(['world_hs','eye_30hz','license_academic'],2)
