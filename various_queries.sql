SHOW databASes;
SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

-- 1. most popular registration day 

SELECT count(*) AS total, dayname(created_at) AS day FROM users
GROUP BY day
ORDER BY total desc
LIMIT 1;
 
-- 2. inactive users, those who didn't post anything

SELECT username, year(users.created_at) AS 'user registered' FROM users
LEFT JOIN photos on 
users.id = photos.user_id
WHERE photos.id is null; 

-- 3. identify users without comments

SELECT username, comment_text FROM users
LEFT JOIN comments on
comments.user_id = users.id
WHERE comments.id is null;

-- 4. what is the single most liked photo in our db?

SELECT photos.id, 
photos.image_url, 
photos.user_id AS author, 
username author_name,
count(likes.user_id)AS likes FROM photos
	JOIN likes on
	likes.photo_id = photos.id
		JOIN users on photos.user_id = users.id -- one more JOIN here to het username form users table
GROUP BY photos.id
ORDER BY count(likes.user_id) desc
LIMIT 1;

-- 5. how many times avg user post?

SELECT
(SELECT count(*) FROM photos) / (SELECT count(*) FROM users) AS avg; 

-- 6. find five most commonly used hashtags

SELECT tag_name, count(*) AS 'most popular tags' FROM tags
JOIN photo_tags on
photo_tags.tag_id = tags.id
GROUP BY tag_name
ORDER BY count(photo_tags.photo_id) desc
LIMIT 5;

-- 7. find users who liked every single photo  

SELECT count(*) AS likes, likes.user_id, username 
FROM users
INNER JOIN likes 
on users.id = likes.user_id
GROUP BY likes.user_id having count(*) = (SELECT count(*) FROM photos) -- here having we compare with counting rows FROM another table
ORDER BY likes desc;


