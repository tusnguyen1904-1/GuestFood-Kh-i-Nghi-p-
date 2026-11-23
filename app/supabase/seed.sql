-- Initial catalog. Existing edited branches and their menus are preserved.
begin;
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v29','Bún Chả Hà Nội Gia Truyền','đại học Quốc gia, Nguyễn Bỉnh Khiêm, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8768294','106.8082741','https://maps.app.goo.gl/4KuqnFxnc4DJchYZ8','ChIJnYq3PK_YdDERxkiEzFD9gHU','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bún chả truyền thống',35000,'phần','bun'),('Bún chả nem',45000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v30','Cơm gà xối mỡ chiên mắm','71/11 Tân Lập, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8782252','106.8097047','https://maps.app.goo.gl/YaTErAbmVLaGJud46','ChIJsZi8GAAhdTER5DKYajyhxuA','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm gà chiên mắm',35000,'phần','com'),('Cơm gà xối mỡ',40000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v31','Bún Đậu Mắm Tôm Gánh','114 Nguyễn Bỉnh Khiêm, khu phố Tân Lập, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8797648','106.8102567','https://maps.app.goo.gl/FYPRk4wfGDeiN8is8','ChIJl3wUVgDZdDER-LSP3KSHbgc','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bún đậu mắm tôm',35000,'phần','bun'),('Bún đậu thập cẩm',45000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v32','Nướng ngói 76','VRJ6+463, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8802515','106.8105464','https://maps.app.goo.gl/XSgt5PD9Gvmi7Lkt8','ChIJm6eNKgDZdDERH3vmCrCKeMg','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Ba chỉ nướng ngói',65000,'phần',''),('Bò nướng ngói',80000,'phần','bo')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v33','Cơm tấm Mai','126 Nguyễn Bỉnh Khiêm, Đông Hòa, Hồ Chí Minh, Việt Nam','10.880421','106.8104784','https://maps.app.goo.gl/gBFrx2oe3ZgEQUTi6','ChIJD_WYhAYndTER4C1dpJIffOk','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm tấm sườn',35000,'phần','com'),('Cơm tấm sườn trứng',40000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v34','Cơm gà xối mỡ Green','Khu Phố 6, Linh Xuân, Hồ Chí Minh, Việt Nam','10.8717282','106.7981846','https://goo.gl/maps/1czmszH2iTwbYDin6','ChIJewDJ807ZdDERNOMSS8ivDm0','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm gà xối mỡ',35000,'phần','com'),('Cơm gà sốt tiêu',40000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v35','Lẩu Chay Đức Lạc','VQMM+6V9, Tô Vĩnh Diện, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8830449','106.7847384','https://www.google.com/maps?cid=3859334469157949967','ChIJQ5pEBzzZdDERD5KUh0AcjzU','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu chay nấm',95000,'nồi','lau'),('Lẩu Thái chay',105000,'nồi','lau')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v36','Lẩu Chay Hữu Duyên','767/6 Tô Vĩnh Diện, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8848594','106.7839086','https://www.google.com/maps?cid=14888146145046959689','ChIJ5ydNuLPZdDERSRagwwlSnc4','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu nấm chay',95000,'nồi','lau'),('Lẩu chay thập cẩm',110000,'nồi','lau')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v37','PaPa Xốt Singapore 3','Đông Hòa, Hồ Chí Minh, Việt Nam','10.8830483','106.7844714','https://goo.gl/maps/xbp5mTBReTQKpKst6','ChIJCUJggwfZdDERQWVLxc8lc4M','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm xèo bò',45000,'phần','com'),('Cơm xèo hải sản',50000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v01','Hằng Thiện Chay - Vegetarian Restaurant','68 Nguyễn Bỉnh Khiêm, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8777398','106.8089017','https://goo.gl/maps/k34qFCzktRuwR9e2A','ChIJE1a_tUHZdDERUU9gQBrAEtM','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm chay nấm kho',28000,'phần','chay'),('Lẩu nấm chay',95000,'nồi','lau'),('Bún chay rau củ',30000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v04','BÚN ĐẬU BOX','Đông Hòa, Hồ Chí Minh, Việt Nam','10.8742738','106.7994206','https://goo.gl/maps/9ayMj6whd49yEURDA','ChIJEapoQg7ZdDERoR166FTVL4k','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bún đậu mắm tôm',35000,'phần','bun'),('Bún đậu chả cốm',40000,'phần','bun'),('Bún đậu đặc biệt',55000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v05','Lẩu chay Tâm Diệu 3','VQFX+HVR, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8739982','106.799651','https://goo.gl/maps/z7XzuDemWb9Jfihj7','ChIJs_klvPHZdDERcQdvXRMeMCA','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bún nấm chay',28000,'phần','bun'),('Cơm chay thập cẩm',30000,'phần','chay'),('Lẩu rau nấm',90000,'nồi','lau')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v07','Bánh mì hà nội','Đường D2/tổ 8 Tân Lập, Khu Phố, Đông Hòa, Hồ Chí Minh, Việt Nam','10.873662','106.8008731','https://goo.gl/maps/XhPU4bFw7VZrrtDA6','ChIJqdvdBTHZdDERXR70VQH7eOQ','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bánh mì thịt nướng',25000,'phần','banh'),('Bánh mì trứng',18000,'phần','banh')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v09','Mộc Lan Quán - Cơm thố & Mì Singapore Làng đại học Thủ Đức','VQFX+XHC, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8749356','106.7988775','https://goo.gl/maps/V3TtS8BKVXWkDwKX6','ChIJe2Wdmz_ZdDER-fv_PapomVM','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm thố gà',38000,'phần','com'),('Mì xào Singapore',40000,'phần','mi'),('Cơm thố bò',45000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v13','Bò né Chu Pin','VQFX+749, Đường T1, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8731734','106.7978699','https://goo.gl/maps/AoVJDwXmWjpc91Ar8','ChIJedrgJhrZdDERImv5wEnk-BA','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Bò né trứng',42000,'phần','bo'),('Bánh mì bò né',48000,'phần','bo')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v16','Cơm tấm Ngô Quyền','21/5 Võ Nguyên Giáp, Linh Xuân, Hồ Chí Minh, Việt Nam','10.8716618','106.7981618','https://goo.gl/maps/9U46eduX2KgZgeTh7','ChIJZcj7kKDYdDERbLBLb6jJWDw','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm tấm sườn bì',35000,'phần','com'),('Cơm sườn bì chả',42000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v19','Phở Lý Quốc Sư Hà Nội| PHỞ NGON LÀNG ĐẠI HỌC| PHỞ NGON THỦ ĐỨC','VQFX+4X3, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8727747','106.7999362','https://goo.gl/maps/EYSfnuTjDAQ7dgjJ8','ChIJOwAjal7ZdDERi9DFW_nvuJY','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Phở tái nạm',45000,'phần','pho'),('Phở bò tái',40000,'phần','pho')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v21','Hủ tiếu 76 Quảng Ngãi','VRF2+87G, Đông Hòa, Hồ Chí Minh, Việt Nam','10.873311','106.800696','https://goo.gl/maps/c36Lhg1qGRFEDyBr5','ChIJfUGUccfZdDER_gm8RWBpKxk','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Hủ tiếu Quảng Ngãi',32000,'phần','mi'),('Hủ tiếu sườn',38000,'phần','mi')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v22','CƠM CHAY THIÊN NHIÊN - Làng Đại Học','9 Đông Hòa, Hồ Chí Minh, Việt Nam','10.8725518','106.7995662','https://goo.gl/maps/oDR5m8DhuikBNiaw5','ChIJN5Q6ZF7ZdDER1x0IETl9dZM','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm chay đậu hũ',25000,'phần','chay'),('Cơm chay nấm kho',28000,'phần','chay')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v24','LẨU NƯỚNG CÔ LIÊN LÀNG ĐH KHU B','VQMP+32M, Bảo Vệ Tuyến Ống Nước Thô, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8827142','106.7850368','https://goo.gl/maps/zPRw4nCorSJuHmPG6','ChIJe5lN9iXZdDER53kR8K23g3I','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu Thái chua cay',120000,'nồi','lau'),('Mì xào bò',40000,'phần','mi')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v25','Quán dê Hưng Mập','161 Tô Vĩnh Diện, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8828601','106.7854609','https://goo.gl/maps/FDddS3Lfs7Y7RXwH8','ChIJxTzzOsbZdDERK1sKVoJ32AY','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu dê',165000,'nồi','lau'),('Dê hấp sả',105000,'đĩa','')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v26','Lẩu Bò Hà Lan','151 Tô Vĩnh Diện, Đông Hòa, Hồ Chí Minh 590000, Việt Nam','10.8830222','106.7850927','https://goo.gl/maps/cVeobf7Gafi2ijV49','ChIJfwIDfg7ZdDERF60V7yqmtBk','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu bò thập cẩm',150000,'nồi','lau'),('Mì xào bò',40000,'phần','mi')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v28','Vua lẩu chay Mị Châu','Đ. Lương Định Của, Tan Hoa, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8836151','106.7839771','https://goo.gl/maps/V3cse2sJwx6btvdm6','ChIJc5dY5FPZdDEREF7bLhck7lA','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu chay rau nấm',100000,'nồi','lau'),('Cơm chay rau củ',30000,'phần','chay')) as d(name,price,unit,photo);
commit;
