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
 values ('v36','Lẩu Chay Hữu Duyên','767/6 Tô Vĩnh Diện, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8848594','106.7839086','https://www.google.com/maps?cid=14888146145046959689','ChIJ5ydNuLPZdDERSRagwwlSnc4','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu nấm chay',95000,'nồi','lau'),('Lẩu chay thập cẩm',110000,'nồi','lau')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v09','Mộc Lan Quán - Cơm thố & Mì Singapore Làng đại học Thủ Đức','VQFX+XHC, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8749356','106.7988775','https://goo.gl/maps/V3TtS8BKVXWkDwKX6','ChIJe2Wdmz_ZdDER-fv_PapomVM','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm thố gà',38000,'phần','com'),('Mì xào Singapore',40000,'phần','mi'),('Cơm thố bò',45000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v16','Cơm tấm Ngô Quyền','21/5 Võ Nguyên Giáp, Linh Xuân, Hồ Chí Minh, Việt Nam','10.8716618','106.7981618','https://goo.gl/maps/9U46eduX2KgZgeTh7','ChIJZcj7kKDYdDERbLBLb6jJWDw','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm tấm sườn bì',35000,'phần','com'),('Cơm sườn bì chả',42000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v24','LẨU NƯỚNG CÔ LIÊN LÀNG ĐH KHU B','VQMP+32M, Bảo Vệ Tuyến Ống Nước Thô, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8827142','106.7850368','https://goo.gl/maps/zPRw4nCorSJuHmPG6','ChIJe5lN9iXZdDER53kR8K23g3I','2026-11-23',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu Thái chua cay',120000,'nồi','lau'),('Mì xào bò',40000,'phần','mi')) as d(name,price,unit,photo);
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
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v38','IU Canteen','VRH2+27J, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8775759','106.8006439','https://maps.app.goo.gl/4NGDiPbKYuCS38wn9','ChIJYZwXc6TYdDERR29dEcBKxco','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm gà',32000,'phần','com'),('Cơm trứng',25000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v39','Quán Ăn - Hai Chị Em','220 Đ. Vành Đai Đhqg Hcm, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8824366','106.8120814','https://maps.app.goo.gl/a8t51PghLtQoi1zS7','ChIJ7Q4TDwDZdDERZKmmwX0yudc','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm sườn',35000,'phần','com'),('Bún thịt nướng',35000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v40','Ốc Hoàng - Ốc Ngon Vành Đai, Làng Đại Học','204 Nguyễn Bỉnh Khiêm, khu phố Tân Lập, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8818706','106.8117508','https://maps.app.goo.gl/oLW2S5PESfUbAszN9','ChIJc6DrTADZdDER30uVhTrenx4','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Ốc hấp sả',45000,'phần',''),('Ốc xào bơ tỏi',55000,'phần','')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v41','Lẩu Bò Triều Châu Làng Đại Học','Nhà Công Vụ 1, Nguyễn Du, Khu đô thị ĐHQG-HCM, Khu phố Tân Hòa, Làng Đại Học Quốc Gia, Đông Hòa, Hồ Chí Minh 70000, Việt Nam','10.8806053','106.7959906','https://maps.app.goo.gl/WvHuv6GJvuUJ6f8YA','ChIJwyzjUADZdDERBaLDdtXa_y8','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu bò',120000,'nồi','lau'),('Mì bò',45000,'phần','mi')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v42','Quán Phở Thanh Vân','84-86 Bảo Vệ Tuyến Ống Nước Thô, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8881249','106.787442','https://maps.app.goo.gl/DafYE5QwATBnYmWSA','ChIJAYeIMgDZdDERJgCZqDX_Jws','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Phở bò tái',40000,'phần','pho'),('Phở bò viên',35000,'phần','pho')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v43','Hủ tiếu 71 làng đại học','đại học Nông Lâm, Đ. Số 4/225 tổ 1, Khu Phố 6, Hiệp Bình, Hồ Chí Minh 700000, Việt Nam','10.8692432','106.7895066','https://www.google.com/maps/search/?api=1&query=H%E1%BB%A7+ti%E1%BA%BFu+71+l%C3%A0ng+%C4%91%E1%BA%A1i+h%E1%BB%8Dc&query_place_id=ChIJry1LSxbZdDER5X2vSbThhwI','ChIJry1LSxbZdDER5X2vSbThhwI','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Hủ tiếu thịt',30000,'phần',''),('Hủ tiếu bò viên',35000,'phần','')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v44','Lẩu chay Hoằng Đạt 2 (cs5)','33/6 Đường, 33/6 Đ. Lương Định Của, Phường, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8839742','106.7838428','https://www.google.com/maps/search/?api=1&query=L%E1%BA%A9u+chay+Ho%E1%BA%B1ng+%C4%90%E1%BA%A1t+2+%28cs5%29&query_place_id=ChIJi9PEvQHZdDEReDIM_l5isy4','ChIJi9PEvQHZdDEReDIM_l5isy4','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu nấm chay',95000,'nồi','lau'),('Bún nấm chay',30000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v45','Cơm gà Tam Kỳ làng đại học','89 Đ. Lương Định Của, KP, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8844927','106.7833066','https://www.google.com/maps/search/?api=1&query=C%C6%A1m+g%C3%A0+Tam+K%E1%BB%B3+l%C3%A0ng+%C4%91%E1%BA%A1i+h%E1%BB%8Dc&query_place_id=ChIJiUP3dADZdDERlM8uYjn4k8k','ChIJiUP3dADZdDERlM8uYjn4k8k','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Cơm gà xé',35000,'phần','com'),('Cơm gà đùi',45000,'phần','com')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v46','Dookki Bcons Dĩ An','38 Đ. Thống Nhất, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8925739','106.7937847','https://www.google.com/maps/search/?api=1&query=Dookki+Bcons+D%C4%A9+An&query_place_id=ChIJO0wpWgDZdDERxCKhkPc-Wa0','ChIJO0wpWgDZdDERxCKhkPc-Wa0','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Buffet lẩu bánh gạo',139000,'phần','lau'),('Lẩu bánh gạo phần đơn',99000,'phần','lau')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v47','Lẩu Cá 44','11/21 Đường Số 1, khu phố Tân Lập, Đông Hòa, Hồ Chí Minh, Việt Nam','10.881256','106.812649','https://www.google.com/maps/search/?api=1&query=L%E1%BA%A9u+C%C3%A1+44&query_place_id=ChIJb2R36aXYdDERS50bl_Jw9Vg','ChIJb2R36aXYdDERS50bl_Jw9Vg','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Lẩu cá',120000,'nồi','lau'),('Bún cá',35000,'phần','bun')) as d(name,price,unit,photo);
with added as (
 insert into public.branches(id,name,address,lat,lon,map,place_id,verified_at,published)
 values ('v48','Phở Thiên Ân làng đại học','Nhà Điều Hành ĐH Khoa học Tự nhiên Tp.HCM, Đông Hòa, Hồ Chí Minh, Việt Nam','10.8756053','106.799651','https://www.google.com/maps/search/?api=1&query=Ph%E1%BB%9F+Thi%C3%AAn+%C3%82n+l%C3%A0ng+%C4%91%E1%BA%A1i+h%E1%BB%8Dc&query_place_id=ChIJOzTk-PbZdDERvctfUyycJRA','ChIJOzTk-PbZdDERvctfUyycJRA','2026-11-24',true) on conflict (id) do nothing returning id
)
insert into public.dishes(branch_id,name,price,unit,photo)
select added.id,d.name,d.price,d.unit,d.photo from added cross join (values ('Phở bò tái',40000,'phần','pho'),('Phở bò chín',40000,'phần','pho')) as d(name,price,unit,photo);
commit;
