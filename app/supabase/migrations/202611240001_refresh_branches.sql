-- Retire the matched location only. Keep its historical references and menu.
with retired as (
 select b.* from public.branches b where b.published and b.place_id in (
  'ChIJCUJggwfZdDERQWVLxc8lc4M',
  'ChIJE1a_tUHZdDERUU9gQBrAEtM',
  'ChIJEapoQg7ZdDERoR166FTVL4k',
  'ChIJN5Q6ZF7ZdDER1x0IETl9dZM',
  'ChIJOwAjal7ZdDERi9DFW_nvuJY',
  'ChIJQ5pEBzzZdDERD5KUh0AcjzU',
  'ChIJedrgJhrZdDERImv5wEnk-BA',
  'ChIJfUGUccfZdDER_gm8RWBpKxk',
  'ChIJqdvdBTHZdDERXR70VQH7eOQ',
  'ChIJs_klvPHZdDERcQdvXRMeMCA',
  'ChIJxTzzOsbZdDERK1sKVoJ32AY'
 ) for update
), changed as (
 update public.branches b set published=false from retired r where b.id=r.id
 returning b.id, to_jsonb(r) as before_edit, to_jsonb(b) as after_edit
)
insert into public.verification_records(branch_id,evidence,previous,current_record)
select id,'Google Maps: hồ sơ báo đóng cửa, đối chiếu 24/11/2026.',before_edit,after_edit from changed;

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
