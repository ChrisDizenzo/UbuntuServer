const express = require('express')
const sqlRoutes = express.Router()

const {Client} = require('pg')
const client = new Client({
    user: "creebindooz",
    password: "Go4itall12",
    host: "localhost",
    port: 5432,
    database: "chatter"
})

client.connect()
.then(()=>{
    console.log("Connected Successfuly to postgres classcards database")
})
.catch((e)=>console.log(e))
// .finally(()=>{client.end()})

sqlRoutes.get('/',(req,res,next) => {
    res.json({test: "Creebo"})
    
})

sqlRoutes.get('/:database',(req,res,next) => {
    console.log("looking for data")
    var queryParameter = req.body

    q = "SELECT "
    if (queryParameter.cols){
        q+='('+queryParameter.cols+')'    
    }else{
        q+='*'
    }
    q+=" FROM " +req.params.database
    
    if (queryParameter.where){
        var where = ' '
        Object.keys(queryParameter.where).forEach((o)=>{
            set+=o+' = '
            if (o.search('id') > 0){
                set += queryParameter.where[o] + ','
            }else{
                set += '\''+ queryParameter.where[o] + '\','
            }
        })
        q+= where.slice(0,-1)
    }

    if (queryParameter.limit){
        q+=" LIMIT " + queryParameter.limit
    }else{
        q+=" LIMIT 15"
    }
    if (queryParameter.offset){
        q+=" OFFSET " + queryParameter.limit
    }
    q+= " ORDER BY " + req.params.database +  "_id DESC"
    console.log(q)
    client.query(q, (err,result) =>{
        if (err){
            console.log(err)
        }else{
            console.log(result.rows)
            res.json(result.rows)
        }
    })
    
})

sqlRoutes.post('/:database',(req,res) => {
    console.log(req.body)
    var queryParameter = req.body

    var into = req.params.database+' ('
    var values = '('
    Object.keys(queryParameter).forEach((o)=>{
        into+=o+','
        if (o.search('id') > 0){
            values += queryParameter[o] + ','
        }else{
            values += '\''+ queryParameter[o] + '\','
        }
    })
    into = into.slice(0,-1) + ')'
    values = values.slice(0,-1) + ')'
    q = "INSERT INTO " + into + " VALUES " + values;
    console.log(q)
    client.query(q, (err,result) =>{
        if (err){
            console.log(err)
            res.json(err)
        }else{
            res.json(result)
        }
    })    
})


sqlRoutes.post('/update/:database',(req,res) => {
    console.log(req.body)
    var queryParameter = req.body

    var set = ''
    Object.keys(queryParameter.set).forEach((o)=>{
        set+=o+' = '
        if (o.search('id') > 0){
            set += queryParameter.set[o] + ','
        }else{
            set += '\''+ queryParameter.set[o] + '\','
        }
    })
    set = set.slice(0,-1) + " WHERE "
    
    queryParameter.where
    var where = ''
    Object.keys(queryParameter.where).forEach((o)=>{
        set+=o+' = '
        if (o.search('id') > 0){
            set += queryParameter.where[o] + ','
        }else{
            set += '\''+ queryParameter.where[o] + '\','
        }
    })
    where = where.slice(0,-1)
    q = "UPDATE " + req.params.database + " SET " + set + " WHERE " + where;
    console.log(q)
    client.query(q, (err,result) =>{
        if (err){
            console.log(err)
            res.json(err)
        }else{
            res.json(result)
        }
    })    
})

module.exports = sqlRoutes