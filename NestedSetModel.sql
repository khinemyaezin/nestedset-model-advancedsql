-- RETRIEVING A FULL TREE
SELECT node.id,node.title
FROM categories AS node,
        categories AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND parent.title = 'root'
ORDER BY node.lft;

-- FINDING ALL THE LEAF NODES
SELECT title
FROM categories
WHERE rgt = lft + 1 ;

-- FINDING THE DEPTH OF THE NODES
SELECT node.id,node.title, (COUNT(parent.title) - 1) AS depth
FROM categories AS node,
        categories AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt 
-- and parent.id=9
GROUP BY node.title,node.lft ,node.id
HAVING (COUNT(parent.title) - 1) <=3
ORDER BY node.lft



-- DEPTH OF A SUB-TREE
SELECT node.id,node.title
, ( (COUNT(parent.title)) - (sub_tree.depth + 1)) AS depth
FROM categories AS node,
        categories AS parent,
        categories AS sub_parent,
        (
                SELECT node.title, (COUNT(parent.title) - 1) AS depth
                FROM categories AS node,
                categories AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                AND node.id = 12
                GROUP BY node.title
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.title = sub_tree.title
GROUP BY node.id,node.title,sub_tree.depth,node.lft
ORDER BY node.lft

-- FIND THE IMMEDIATE SUBORDINATES OF A NODE
-- Imagine you are showing a category of electronics products on a retailer web site.
-- When a user clicks on a category, you would want to show the products of that category, 
-- as well as list its immediate sub-categories, but not the entire tree of categories beneath it.
-- For this, we need to show the node and its immediate sub-nodes, but no further down the tree. For example, 
-- when showing the PORTABLE ELECTRONICS category,
-- we will want to show MP3 PLAYERS, CD PLAYERS, and 2 WAY RADIOS, but not FLASH.
-- This can be easily accomplished by adding a HAVING clause to our previous query:
SELECT node.id,node.title, (COUNT(parent.id) - (sub_tree.depth + 1)) AS depth
FROM categories AS node,
        categories AS parent,
        categories AS sub_parent,
        (
                SELECT node.id, (COUNT(parent.id) - 1) AS depth
                FROM categories AS node,
                        categories AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                        AND node.id = 35
                GROUP BY node.id,node.title,node.lft
                 ORDER BY node.lft
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.id = sub_tree.id
GROUP BY node.id,node.title,sub_tree.depth,node.lft
HAVING (COUNT(parent.id) - (sub_tree.depth + 1)) <= 1
ORDER BY node.lft;

-- structure all tree
SELECT node.id, CONCAT( REPEAT( '>', (COUNT(parent.title) - 1)::integer ), node.title) AS name, node.lft,node.rgt
FROM categories AS node,
        categories AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
GROUP BY node.title,node.lft,node.id,node.lft,node.rgt
ORDER BY node.lft;

--SINGLE PATH
SELECT parent.title
FROM categories AS node,
        categories AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.id = 35
ORDER BY parent.lft
