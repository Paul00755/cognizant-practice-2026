// use college_nosql

// TASK 1 : CREATE COLLECTION & INSERT DOCUMENTS

db.createCollection("feedback")

db.feedback.insertMany([
{
student_id:1,
course_code:"CS101",
semester:"2022-ODD",
rating:5,
tags:["challenging","good"],
comments:"Excellent"
},
{
student_id:2,
course_code:"CS101",
semester:"2022-ODD",
rating:4,
tags:["challenging"],
comments:"Good"
},
{
student_id:3,
course_code:"CS102",
semester:"2022-ODD",
rating:2,
tags:["difficult"],
comments:"Average"
}
])

db.feedback.insertOne({
student_id:4,
course_code:"CS102",
semester:"2022-ODD",
rating:5
})

db.feedback.countDocuments()


// TASK 2 : CRUD OPERATIONS


db.feedback.find({
rating:5
})

db.feedback.find({
course_code:"CS101",
tags:"challenging"
})

db.feedback.find(
{},
{
student_id:1,
course_code:1,
rating:1,
_id:0
}
)

db.feedback.updateMany(
{rating:{$lt:3}},
{$set:{needs_review:true}}
)

db.feedback.updateMany(
{needs_review:true},
{$push:{tags:"reviewed"}}
)

db.feedback.deleteMany({
semester:"2021-EVEN"
})


// TASK 3 : AGGREGATION PIPELINE


db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{$group:{
_id:"$course_code",
avg_rating:{$avg:"$rating"},
total:{$sum:1}
}},
{$sort:{avg_rating:-1}}
])

db.feedback.aggregate([
{$match:{semester:"2022-ODD"}},
{$group:{
_id:"$course_code",
avg_rating:{$avg:"$rating"},
total:{$sum:1}
}},
{$project:{
course_code:"$_id",
average_rating:{$round:["$avg_rating",1]},
total:1,
_id:0
}}
])

db.feedback.aggregate([
{$unwind:"$tags"},
{$group:{
_id:"$tags",
count:{$sum:1}
}},
{$sort:{count:-1}}
])


// TASK 4 : INDEXING

db.feedback.createIndex({
course_code:1
})

db.feedback.find({
course_code:"CS101"
}).explain("executionStats")