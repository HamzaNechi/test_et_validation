import reclamation from "../models/reclamation.js";
import nodemailer from 'nodemailer';

export function addReclamation(req,res){
    const rec=new reclamation({
        email:req.body.email,
        message:req.body.message,
    });

    rec.save().then((rc)=>{
        res.status(201).json(rc);
    }).catch(err => {
        console.log(err);
        res.status(400).json({error:err});
    })
}



export async function getReclamations(req,res){
    reclamation.find().then(docs =>{
        res.status(200).json(docs);
    }).catch(err =>{
        res.status(400).json({error:err});
    })
}

export function ReponseReclamation(req,res){
    const transporter = nodemailer.createTransport({
       service:"gmail",
       auth: {
        user: process.env.EMAIL, //REPLACE WITH YOUR EMAIL ADDRESS
        pass: process.env.KEY_GMAIL //REPLACE WITH YOUR EMAIL PASSWORD
        },
    });
   
    let info = transporter.sendMail({
        from: "hamza.nechi@esprit.tn",
        to:req.body.email,
        subject:"Dear Self-Response reclamation",
       // text:"Your room name is hza",
        html:"<html><center><h1>Response</h1><br><p>"+req.body.text+"</p></center></html>"
    });

    transporter.sendMail(info, function (error, info) {
        res.status(200).json({msg:"sended"});
    });
}

export function deleteReclamation(req,res){
    reclamation.findByIdAndDelete({_id:req.params.recId}).then( msg =>{
        res.status(200).json(msg);
    }).catch(err =>{
        res.status(400).json({error:err});
    })
}