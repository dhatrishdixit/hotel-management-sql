-- after importing all the csv files 
use hotel_management;

-- 1 Retrieve the name and email of all guests who have checked in
SELECT Name, Email FROM Guests WHERE CheckInDate IS NOT NULL;

-- 2 Count the total number of rooms in the rooms table.
SELECT COUNT(*) FROM rooms ;

-- 3 Retrieve the full names of guests who have booked a room.
SELECT g.name
FROM bookings AS b 
LEFT JOIN guests AS g ON b.guestId = g.guestId ;

-- 4 Select all bookings where the guest's first name is "John."
SELECT DISTINCT g.name
FROM bookings AS b 
LEFT JOIN guests AS g ON b.guestId = g.guestId 
WHERE g.name LIKE "John%";

-- 5 Calculate the total revenue generated from all bookings.
SELECT SUM(r.pricepernight) as total_revenue_generated
FROM bookings AS b 
LEFT JOIN rooms AS r ON b.roomId = r.roomId;

-- 6  Find the room type that has been booked the most.
SELECT r.roomtype , COUNT(*) AS bookings
FROM bookings AS b 
LEFT JOIN rooms AS r ON b.roomId = r.roomId
GROUP BY r.roomtype 
ORDER BY COUNT(*) DESC
LIMIT 1 ;

-- 7 list of rooms that have not been booked
SELECT r.roomid as "Rooms not booked by anyone "
FROM rooms r
LEFT JOIN bookings b ON r.roomid = b.roomid
WHERE b.roomid IS NULL;

-- 8 Calculate the average price of all rooms.
SELECT AVG(pricepernight) AS "Average price of room" FROM rooms;

-- 9 Find all guests who have made more than one booking
SELECT g.guestid ,g.name, COUNT(*) AS bookingcount
FROM guests g
JOIN bookings b ON g.guestid = b.guestid
GROUP BY g.guestid ,g.name
HAVING COUNT(*) > 1;

-- 10 Find the guest who stayed the longest (based on check_in_date and check_out_date).
SELECT g.name, DATEDIFF(b.checkoutdate, b.checkindate) AS stay_duration 
FROM bookings b
JOIN guests g ON b.guestid = g.guestid
ORDER BY stay_duration DESC
LIMIT 1;

-- 11 find the most expensive room that has been booked 
SELECT r.roomid , r.pricepernight as price
FROM rooms r
JOIN bookings b ON r.roomid = b.roomid
ORDER BY price DESC
LIMIT 1;

-- 12 find first and last booking date of each customer 
SELECT g.guestid, g.name , MIN(b.bookingdate) AS first_booking, MAX(b.bookingdate) AS last_booking
FROM guests g
JOIN bookings b ON g.guestid = b.guestid
GROUP BY g.guestid,g.name;

-- 13 Calculate the occupancy rate for each room (number of days booked divided by total days available).
SELECT r.roomid, 
       SUM(DATEDIFF(b.checkoutdate, b.checkindate)) AS days_booked, 
       ROUND(SUM(DATEDIFF(b.checkoutdate, b.checkindate)) / DATEDIFF(MAX(b.checkoutdate), MIN(b.checkindate)),0) AS occupancy_rate
FROM rooms r
JOIN bookings b ON r.roomid = b.roomid
GROUP BY r.roomid;


-- 14 Find the room that has generated the most revenue
SELECT r.roomid, ROUND(SUM(r.pricepernight*DATEDIFF(b.checkoutdate,b.checkindate)),0) AS total_revenue
FROM rooms r
JOIN bookings b ON r.roomid = b.roomid
GROUP BY r.roomid
ORDER BY total_revenue DESC
LIMIT 1;

-- 15 find the top five guest who spent the most money 
SELECT g.guestid, g.name , ROUND(SUM(r.pricepernight*DATEDIFF(b.checkoutdate,b.checkindate)),0) AS total_spent
FROM guests g
JOIN bookings b ON g.guestid = b.guestid
JOIN rooms r ON b.roomid = r.roomid
GROUP BY g.guestid,g.name
ORDER BY total_spent DESC
LIMIT 5;

-- 16 Find the names of guests who have booked the most expensive room type.
SELECT Name , roomtype
FROM guests 
WHERE RoomType = (
    SELECT Roomtype 
    FROM ROOMS
    WHERE pricepernight = (SELECT MAX(pricepernight) FROM rooms)
);

 
 -- 17 List the RoomID and RoomType for rooms that were booked for a total amount higher than the average booking amount.
SELECT RoomID, RoomType 
FROM rooms 
WHERE RoomID IN (
     SELECT RoomId 
     FROM Bookings
     WHERE totalamount > (SELECT AVG(totalamount) FROM Bookings)
);
 
 
 -- 18 Find the GuestID and Name of guests who stayed more than the average number of days.
SELECT guestId , name FROM Guests 
WHERE DATEDIFF(checkoutdate,checkindate) > (
		SELECT AVG(DATEDIFF(checkoutdate,checkindate)) FROM Bookings
 );

 -- 19 Show the RoomID, RoomType, and guest names for rooms that are not available (IsAvailable = 'No').
 SELECT r.roomId,r.roomType,g.name
 FROM Rooms AS r 
 JOIN Bookings AS b ON b.roomId = r.roomId 
 JOIN Guests AS g ON b.guestId = g.guestId ;
 
 
 -- 20 find the roomid and roomtype of rooms that have never been booked \
 SELECT roomid , roomtype FROM rooms 
 WHERE roomid NOT IN (SELECT roomid FROM bookings);
