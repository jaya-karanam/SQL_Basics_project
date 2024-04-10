-- 1. Create an ER diagram or draw a schema for the given database.
/* steps to draw ER diagram
1. click on database tab
2. go to reverse Engineer click on it
3. select local instance mysql80 on stored connection
4. click next and again next 
5. select the database which yiu want to draw on ER diagram and click on next .
6. click on next and then click on execute.
7.click on next,next and finsh.
*/

-- 2.We want to reward the user who has been around the longest,
-- Find the 5 oldest users.
SELECT * 
FROM users 
ORDER BY created_at 
LIMIT 5;

-- 3.To target inactive users in an email ad campaign, 
-- find the users who have never posted a photo.
SELECT * FROM users;
SELECT * FROM photos;
SELECT username 
FROM users u 
WHERE u.id NOT IN 
(SELECT DISTINCT user_id FROM photos);

--  4.Suppose you are running a contest to 
-- find out who got the most likes on a photo. Find out who won?
WITH cte1 AS(
SELECT COUNT(photo_id) AS most_likes, 
photo_id FROM likes
GROUP BY photo_id
ORDER BY most_likes DESC
LIMIT 1), 
cte2 AS (
SELECT user_id 
FROM photos p 
JOIN cte1 c ON c.photo_id=p.id),
cte3 AS(
SELECT username 
FROM users u 
JOIN cte2 c2 ON c2.user_id=u.id
)
SELECT cte2.*,cte3.*,cte1.* FROM cte1,cte2,cte3;

-- 5.The investors want to know how many times does the average user post.
SELECT ROUND((SELECT COUNT(*) 
FROM photos)/
(SELECT COUNT(*) FROM users))
 AS avg_user_post;

-- 6.A brand wants to know which hashtag to use on a post, and
-- find the top 5 most used hashtags.
SELECT COUNT(*) AS tag_count,pt.tag_id,t.tag_name 
FROM photo_tags pt 
JOIN tags t ON pt.tag_id=t.id
GROUP BY tag_id 
ORDER BY COUNT(*) DESC LIMIT 5;
  
-- 7. To find out if there are bots, 
-- find users who have liked every single photo on the site.
SELECT * FROM likes;
SELECT * FROM photos; 
SELECT likes.user_id,COUNT(*) AS pic_likes 
FROM likes 
GROUP BY likes.user_id 
HAVING pic_likes = (SELECT COUNT(*) FROM photos);

-- 8.Find the users who have created instagramid in may 
-- and select top 5 newest joinees from it?
SELECT * FROM users;
SELECT username,created_at FROM users 
 WHERE  MONTHNAME(created_at)='may'
ORDER BY created_at DESC 
LIMIT 5;

-- 9.Can you help me find the users whose name starts with c and 
-- ends with any number and have posted
 -- the photos as well as liked the photos?

WITH CTE AS(
SELECT DISTINCT u.id,u.username FROM users u 
JOIN photos p ON u.id=p.user_id
JOIN likes l ON u.id=l.user_id)
SELECT * FROM CTE 
WHERE username REGEXP '^c.*[0-9]$';


-- Demonstrate the top 30 usernames to the company who have posted photos
--  in the range of 3 to 5.
SELECT u.id,u.username,COUNT(p.id) AS tot_pics 
FROM users u 
JOIN photos p ON u.id=p.user_id
GROUP BY u.id,u.username
HAVING tot_pics BETWEEN 3 AND 5 
ORDER BY  tot_pics DESC 
LIMIT 30;
