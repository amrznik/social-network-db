-- SQL Queries for Application Requirements
-- @author Amir

INSERT INTO role(role_id,role_name)
VALUES (0,"Normal");
INSERT INTO role(role_id,role_name)
VALUES (1,"Editor");
INSERT INTO role(role_id,role_name)
VALUES (2,"Analyser");

------------------------------------------------------

INSERT INTO thumb_up(status_id, user_id)
VALUES (6,1);
INSERT INTO thumb_up(status_id, user_id)
VALUES (6,2);
INSERT INTO thumb_up(status_id, user_id)
VALUES (6,3);
INSERT INTO thumb_up(status_id, user_id)
VALUES (6,6);

------------------------------------------------------
-- Query 1
-- Registering a user

INSERT INTO user(token,username,password,name_first,name_middle,name_last,email_id,picture,online,created_at)
SELECT 1,"David","12345678","David",' ',"Foo","David_Foo@yahoo.com",'9',1,current_time
FROM dual
WHERE NOT EXISTS (SELECT *
                  FROM user
                  WHERE user.username = "David" OR
                  		user.email_id = "David_Foo@yahoo.com");

INSERT INTO user_has_role(user_id,role_id)
SELECT user_id, role_id
FROM ((SELECT user_id FROM user WHERE username = "David") AS T1,
	 (SELECT role_id FROM role WHERE role_name = "Analyser") AS T2);

------------------------------------------------------
-- Query 2
-- Creating a new Editor

INSERT INTO user(token,username,password,name_first,name_middle,name_last,email_id,picture,online,created_at)
SELECT 1,"Alex","12345678","Alex",' ',"Bar","Alex_Bar@yahoo.com",'9',1,current_time
FROM dual
WHERE NOT EXISTS (SELECT *
                  FROM user
                  WHERE user.username = "Alex" OR
                  		user.email_id = "Alex_Bar@yahoo.com");

INSERT INTO user_has_role(user_id,role_id)
SELECT user_id, role_id
FROM ((SELECT user_id FROM user WHERE username = "Alex") AS T1,
	 (SELECT role_id FROM role WHERE role_name = "Editor") AS T2);

------------------------------------------------------
-- Query 3
-- New post by a user with two hashtags

INSERT INTO status(message, created_at, user_id)
select "This is a test", current_time, 1
from dual
where not exists(SELECT *
                  FROM status
                  WHERE status.message = "This is a test" and
                  		status.user_id = 1);

INSERT INTO status_parent(status_id, status_parent_id)
select max(status_id), max(status_id)
from status;

INSERT INTO tag(tag_name, status_id)
select "#Test", s.status_id
from status s
where s.message = "This is a test" and
                  		s.user_id = 1 and 
                        not exists(SELECT *
								   FROM tag
								   WHERE tag.status_id = s.status_id and
								   tag.tag_name = "#Test");
INSERT INTO tag(tag_name, status_id)
select "#Test_Message", s.status_id
from status s
where s.message = "This is a test" and
                  		s.user_id = 1 and 
                        not exists(SELECT *
								   FROM tag
								   WHERE tag.status_id = s.status_id and
								   tag.tag_name = "#Test_Message");
                                   
INSERT INTO status_has_tag(tag_id,status_id)
SELECT tag_id, status_id
FROM ((SELECT tag_id FROM tag WHERE tag_name = "#Test") AS T1,
	 (SELECT status_id FROM status WHERE status.message = "This is a test" and
										 status.user_id = 1	) AS T2);
INSERT INTO status_has_tag(tag_id,status_id)
SELECT tag_id, status_id
FROM ((SELECT tag_id FROM tag WHERE tag_name = "#Test_Message") AS T1,
	 (SELECT status_id FROM status WHERE status.message = "This is a test" and
										 status.user_id = 1	) AS T2);

------------------------------------------------------
-- Query 4
-- Viewing a list of users who have followed all their followers

/*insert into follower(follower_id, user_id) values (1,2);
insert into follower(follower_id, user_id) values (3,2);

insert into following(following_id, user_id) values (1,2);
insert into following(following_id, user_id) values (3,2);*/

select distinct u.username
from follower f1, user u
where f1.user_id = u.user_id and 
	  not exists (select f2.follower_id
				  from follower f2
                  where f2.follower_id not in (select f3.following_id
											   from following f3
                                               where f1.user_id = f3.user_id));
	  

------------------------------------------------------	
-- Query 5
/* Viewing a list of users who have only followed users who post at least once a day since
their registration */

SELECT u1.username
FROM user u1, following f1
WHERE u1.user_id = f1.user_id AND 
	  not exists (SELECT f2.following_id
			      FROM following f2
				  WHERE f1.user_id = f2.user_id and 				
						f2.following_id not in (select days.suid
												from (select distinct to_days(s.created_at) as statusDay,
															 s.user_id suid, 
                                                             to_days(u2.created_at) as userDay
													  from status s, user u2
													  where s.user_id = u2.user_id) as days
												group by days.suid , days.userDay
												having count(days.statusDay) = to_days(curdate()) - userDay + 1));

------------------------------------------------------
-- Query 6
-- Viewing last n (e.g., n=5) messages (status) of a user 

/*INSERT INTO status(message, created_at, user_id, depth, parent_id) values ("Hi, how are you?", current_time(), 2, 0, 4);
INSERT INTO status(message, created_at, user_id, depth, parent_id) values ("SQL Queries", current_time(), 2, 0, 4);*/

select s.message, s.created_at
from following as f, status as s
where f.user_id = 2 and following_id = s.user_id
order by s.created_at desc
limit 5

------------------------------------------------------
-- Query 7
/* Viewing the top status (based on the number of likes, comments, likes of comments,
replies to a comment, replies to the replies of a comment, and likes of the replies) */

/*SELECT p.text
FROM post p,comment c,plike pl,clike cl
WHERE p.post_id = c.post_id, pl.post_id = p.post_id, cl.comment_id = c.comment_id
ORDER BY (SELECT COUNT(*) FROM comment WHERE comment_id = c.comment_id)
+(SELECT COUNT(*) FROM plike WHERE post_id = pl.post_id)
+(SELECT COUNT(*) FROM clike WHERE comment_id = cl.comment_id);*/


select s1.message, s1.status_id, ((select count(th1.user_id)
								   from thumb_up as th1
								   where th1.status_id = s1.status_id) * 4 + 
						   
								  (select count(*)
								   from status as s2
								   where s2.parent_id = s1.status_id) + 
                                    
								  (select count(*)
								   from status as s2, thumb_up as th2
								   where s2.parent_id = s1.status_id and
										 s2.status_id = th2.status_id) * 3 + 

								  (select count(*)
								   from status_parent as sp, status s3
								   where sp.status_parent_id = s1.status_id and										
                                         sp.status_id = s3.status_id and
                                         s3.depth >= 2) +
                                     
								  (select count(*)
								   from status_parent as sp, thumb_up as th3, status s4
								   where sp.status_parent_id = s1.status_id and
										 sp.status_id = th3.status_id and										
                                         sp.status_id = s4.status_id and
                                         s4.depth >= 2) * 2
                                     
								   )as topStatus
from status as s1
where s1.depth = 0
order by topStatus desc

------------------------------------------------------
-- Query 8
/* When a user searches a hashtag: viewing all posts with n (e.g., n=3) likes which
include the hashtag */

SELECT s.message, s.status_id
FROM status s, tag t
WHERE s.status_id = t.status_id AND 
	  t.tag_name = "#Test" AND 
      3 <= (SELECT count(*) 
			FROM thumb_up 
            WHERE status_id = s.status_id)
ORDER BY (SELECT COUNT(*) 
		  FROM thumb_up 
          WHERE status_id = s.status_id) desc;

------------------------------------------------------
-- Query 9
/* When a user searches a hashtag: viewing all posts which include the hashtag. First,
show the posts of the user's following users, then show the posts with at most one more
additional hashtag (in order of date) and finally, show the posts with at least two
more additional hashtags (in order of number of hashtags) */

/*SELECT k.text
FROM comment k,tag t
WHERE t.text = usersearchtext AND c.comment_id = t.post_id AND k.comment_id IN
(
SELECT c.comment_id
FROM user s,follow f,user t,comment c
WHERE s.user_id = f.follow_id AND f.user_id = t.user_id AND t.user_id = c.user_id
)

SELECT c.text
FROM comment c,tag t
WHERE t.text = usersearchtext AND c.comment_id = t.post_id*/

(select s.message, f.following_id as sort
 from status as s, following as f, tag as t
 where s.user_id = f.following_id and 
 	   f.user_id = 2 and 
 	   t.status_id = s.status_id and
 	   t.tag_name = "#Test"
)       

union all

(select s.message, s.created_at as date
 from status as s, (select t.status_id
				    from tag as t
					group by t.status_id
					having count(tag_name) <= 2) as status_tag, tag as t1
 where s.status_id = status_tag.status_id and 
 	   status_tag.status_id = t1.status_id and 
 	   t1.tag_name = "#Test" and
	   s.user_id not in (select f.following_id
 						 from following as f
						 where f.user_id = 2)                        
order by date desc)

union all

(select s.message, status_tag.tag_count as numberOftag
 from status as s, (select t.status_id, count(tag_name) as tag_count
					from tag as t
					group by t.status_id
					having count(tag_name) >= 3) as status_tag, tag as t1
 where s.status_id = status_tag.status_id and 
 	   status_tag.status_id = t1.status_id and 
 	   t1.tag_name = "#Test" and
	   s.user_id not in (select f.following_id
 						 from following as f
						 where f.user_id = 2)  
order by numberOftag asc)

------------------------------------------------------
-- Query 10
-- Viewing most-liked posts which include at least one of the first n trends (e.g., n=5)

create table trend as
select t.tag_name, count(t.status_id) as numberOfstatus
from tag as t, status as s
where datediff(now() - interval 1 day, s.created_at) >= 0 and 
	  t.status_id = s.status_id
group by t.tag_name
order by numberOfstatus desc
limit 5;

select distinct s.status_id, s.message, t.tag_name
from tag as t, status as s, (select t.tag_name as tname, max((select count(*)
  						   								 	  from thumb_up as th
 						   									  where th.status_id = t.status_id)) as numberOfThumbUp
 						     from tag as t
 						     where t.tag_name in (select trend.tag_name
							  					  from trend)
 						     group by t.tag_name) as tth
where t.tag_name = tth.tname and 
	  s.status_id = t.status_id and
	  tth.numberOfThumbUp = (select count(*)
							 from thumb_up as th
							 where th.status_id = t.status_id);
drop table trend;

------------------------------------------------------
-- Query 11
-- A user can like another user's posts if they did not block each other

insert into thumb_up(status_id, user_id)
select 9, 7
from status as s
where s.user_id <> 7 and 
	  s.status_id = 9 and
      7 not in (select blocking_id
				from user_block
				where blocker_id = s.user_id) and
	  s.user_id not in (select blocking_id
						from user_block
						where blocker_id = 7);

------------------------------------------------------
-- Query 12
-- Deleting a post if the number of posts under this post is at most n (e.g., n=2)

create table status_parent2 as (select status_id, status_parent_id
								from status_parent);
delete from status
where (status_id in (select sp2.status_id
					 from status_parent2 as sp2
					 where sp2.status_parent_id = 10)) and
	  (10 in (select numStatus.spsp
			 from (select sp.status_id as sps, sp.status_parent_id as spsp
 				   from status as s, status_parent as sp
 				   where s.status_id = sp.status_parent_id and s.user_id = 6) as numStatus
			 group by numStatus.spsp
			 having count(numStatus.sps) <= 2));
drop table status_parent2;

------------------------------------------------------
-- Query 13
/* Identifying fake user accounts who publish less than 0.1 posts daily on average, but
more than half of their likes is for another user's posts */

select  (select username
		 from user
         where user_id = fth.f2) as fake_User, 
		(select username
		 from user
		 where user_id = fth.f1) as another_Account
from (select mth.l1 as f1, mth.l2 as f2
 	  from (select count(*) as c,
				   thth.ther_id as l1,
				   thth.thed_id as l2
  			from (select th.user_id as ther_id, 
						 s.user_id as thed_id
 				  from thumb_up as th, status as s
 				  where th.status_id = s.status_id) as thth
 			group by thth.ther_id, thth.thed_id) as mth,
 		   (select count(*) as c,
                   user_id
 			from thumb_up
 			group by user_id) as nth
 	 where mth.l1 = nth.user_id and (mth.c) * 2 > nth.c) as fth,
	(select numStatus.uu as f1, (numStatus.c/alldays.days) as averg
	 from (select u.user_id as uu, (select count(*)
									from status as s
									where u.user_id = s.user_id) as c
 		   from user as u) as numStatus,
 		  (select to_days(curdate()) - to_days(u.created_at) as days,
				  u.user_id as uu
 		   from user as u) as alldays
 	 where numStatus.uu = alldays.uu) as noStatus
where (averg <= 0.1) and fth.f1 = noStatus.f1;

------------------------------------------------------
-- Query 14
-- See Query 18

------------------------------------------------------
-- Query 15
/* The Editor role should automatically be assigned to a user with at least n posts (e.g.,
n=5) */

delimiter |
create trigger editor after insert on status
for each row
begin
update user_has_role
set user_has_role.role_id = 1
where user_has_role.user_id = New.user_id and (select count(*)
											   from status
											   where status.user_id = New.user_id) >= 5;
end;
|

------------------------------------------------------
-- Query 16
/* Viewing a list of users who published at least n posts (e.g., n=2) under each post of
another user */

select statusChild.suid, count(*)
from (select sparent.suid, sparent.spid, count(*) as cp
	 from (select s1.user_id as suid, s1.status_id as sid,
				  s1.depth as d, sp1.status_parent_id as spid 
		   from status as s1, status_parent as sp1 
		   where s1.status_id = sp1.status_id) as sparent
	 where sparent.d >= 1
	 group by sparent.suid, sparent.spid
	 having count(*) >= 2) as statusChild
group by statusChild.suid
having count(*) >= 1;

------------------------------------------------------
-- Query 17
/* A user (e.g., user 1) can send a private message to another user (e.g., user 2)
provided that receiving private messages is enabled in user 2's profile and the user 2's
number of received privates messages is less than n (e.g., n=5) so far, and user 1 and 2
did not block each other */

insert into message(message, created_at, user_id, user_id1)
select "This is a message", current_time, 1, 2
from user 
where user_id = 2 and user_id not in (select user_id1
									  from message 
									  group by user_id1
									  having count(message_id) >= 5) and
					  user_id not in (select user_id 
									  from profile
                                      where is_receiver = 0) and
					  user_id not in (select blocking_id
									  from user_block
									  where blocker_id = 1) and
					  1 not in (select blocking_id
								from user_block 
								where blocker_id = 2);

/*The message sent from user_id = 1(sender) to user_id = 2(receiver)*/

------------------------------------------------------
-- Query 18
-- A user can reply to a status with max. depth of 2

insert into status(message, user_id, depth, parent_id)
select "Query 18", 1, s1.depth+1, 5
from status as s1, status_parent as sp1
where (s1.status_id = 5 and s1.depth <= 2 ) and 
	   sp1.status_id = 5 and "Query 18" not in (select s2.message
												from status as s2, status_parent as sp2, status_parent as sp3
												where sp2.status_id = s2.status_id and 
													  sp2.status_parent_id = sp3.status_parent_id and 
                                                      s2.user_id = 1 and 
                                                      sp3.status_id = 5);
insert into tag(status_id, tag_name)
select max(status_id) as ms,"#Q18"
from status
having ms not in(select status_id
				 from status_parent);

insert into status_parent(status_id, status_parent_id)	
select max(s.status_id), sp.status_parent_id 
from status as s, status_parent as sp
where sp.status_id = 5;