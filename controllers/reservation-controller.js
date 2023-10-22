import reservation from '../models/reservation.js'
import user from '../models/user.js'
import therapy from '../models/therapy.js'
import nodemailer from "nodemailer";
import { decrypt, encrypt } from "../utils/Crypto.js"
class reserv{
    constructor(id,patient,status ,date) {
      this.id = id;
      this.patient = patient;
      this.status = status;
      this.date = date;
   
    
    }
  }

async function sendConfEmail(email) {
    // create reusable transporter object using the default SMTP transport
    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'testforprojet66@gmail.com',
            pass: 'lkcilfntxuqzeiat',
        },
    })
  
    transporter.verify(function (error, success) {
        if (error) {
            console.log(error)
            console.log('Server not ready')
        } else {
            console.log('Server is ready to take our messages')
        }
    })
  
    const mailOptions = {
        from: 'testforprojet66@gmail.com',
        to: email,
        subject: 'Confirmation ',
        html: '<h2>You have been reserved for the therapy : </h2>',
    }
  
    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error)
        } else {
            console.log('Email sent: ' + info.response)
        }
    })
  }

export async function sendRequest(req, res) {
    console.log(req.body.patient_id);
    //fetch reservation
    const resr=await reservation.find({patient:req.body.patient_id,therapy:req.body.therapy_id}).count();
    console.log('resr ligne 48 = '+resr);

    //verifier capacité
    var cap=0;
    const ther=await therapy.findById(req.body.therapy_id);
    if(ther){
        cap=ther.capacity;
    }
    
    const reservNumber=await reservation.find({therapy:req.body.therapy_id}).count();
    if((resr <= 0) && (reservNumber < cap)){
        const invi = new reservation({
            patient: req.body.patient_id,
            therapy: req.body.therapy_id,
        })

        invi.save()
        .then((doc) => {
            //send request req.body.patient_id
            
            user.findOne({_id:req.body.patient_id.trim()}).then( u =>{
                const em=decrypt(u.email);
                sendConfEmail(em);
           }).catch(err =>{
            console.log("not user");
           });
            
            res.status(201).json(doc)
        })
        .catch((err) => {
            res.status(400).json(err)
        })

        sendConfEmail(req.body.patient_id);
    }else{
        if(resr > 0){
            res.status(401).json({error:"You have already reserved."});
        }else{
            res.status(402).json({error:"Sorry ! All seats are already reserved."});
        }
        
    }

    }

export function acceptRequest(req, res) {
    const inv = reservation.findOne({ _id: req.body.id }) 
    if (inv) {
        inv.updateOne({ status: 'accepter' })
            .then((doc) => {
                res.status(200).json(doc)
            })
            .catch((err) => {
                res.status(400).json(err)
            })
    } else {
        res.status(404).json({ error: 'reservation not found !' })
    }
}
export async function approuveAppointement(req, res) {

    const approuveApp = await reservation.findOneAndUpdate({ _id: req.body._id },
        {
            status : "accepted"
         },
    );
    res.status(200).send({ message: "Accepted with success", approuveApp: approuveApp });
  
    
  }
  
  //cancel appointementpa
  export async function cancelAppointement(req, res) {
  
    const canceledApp = await reservation.findOneAndUpdate({ _id: req.body._id },
        {
            status : "canceled"
         },
    );
    const app=await reservation.findOne({_id: req.body._id}).populate('patient');
    const email = decrypt(app.patient.email);
    const transporter = nodemailer.createTransport({
      service:"gmail",
      auth: {
        user: 'testforprojet66@gmail.com',
        pass: 'lkcilfntxuqzeiat',
       },
      });
  
      let info = transporter.sendMail({
          from: "hamza.nechi@esprit.tn",
          to:email,
          subject:"Reservation Status",
          // text:"Your room name is hza",
          html:"<html><center><h1>The doctor has canceled your reservation</h1></center></html>"
      });
  
      transporter.sendMail(info, function (error, info) {
          console.log("mail scheduler sended");
      });
    res.status(200).send({ message: "Canceled with success", canceledApp: canceledApp });
  
    
  }
  
//if user refuse invi then delete invi
export function refuseRequest(req, res) {
    reservation
        .findOneAndDelete({ _id: req.body.id })
        .then((doc) => {
            res.status(200).json(doc)
        })
        .catch((err) => {
            res.status(400).json(err)
        })
}

/*export async function getInvitationsAttente(req,res){
    const invs =await invitation.find({destinataire:req.params.currentUser, status:"En attente"}).populate({ 
        path: 'destinataire', 
      }).populate({ 
        path: 'expediteur', 
      })
    if(invs){
        res.status(200).json(invs)
    }else{
        res.status(400).json({err:"Probléme !"})
    }
}*/


export async function getAll(req, res) {
    console.log(req)
    var apps = [];

const reservations =
            await reservation
                .find({ doctor: req.params.doctor_id })
                .populate('patient')
             
                .populate('therapy');
        
        reservations.forEach((element) => {
            const patientObj = {
              fullName: decrypt(element.patient.fullName),
              phone: decrypt(element.patient.phone),
              email: decrypt(element.patient.email),
            };
            
            //id,user,doctor,role ,date,time,day,upcoming,canceled,statuss
            const app = new reserv(
              element._id,
              patientObj,
              element.status,
              element.date,
           
            );
            
            apps.push(app);
          });
          if (reservations) {
            res.status(200).json({ apps });
          } else {
            res.status(403).send({ message: "Fail : No Appointements" });
          }
        
}
export function deleteOnce(req, res) {
    reservation
        .findById(req.params.id)
        .deleteOne()
        .then((doc) => {
            res.status(200).json(doc)
        })
        .catch((err) => {
            res.status(500).json({ error: err })
        })
}


//get all users for notification
export async function listEmails(req,res){
    var emails=[];
  const reservations = await reservation.find({status : 'En attente'}).populate('patient');
  reservations.forEach((el) => {
    emails.push(decrypt(el.patient.email));
  });
  var emailsFil=emails.filter((el,pos)=>{
    return emails.indexOf(el) == pos;
  })
  res.status(200).json(emailsFil);
        
}


export async function NumberOfReservation(req,res){
    console.log('req id therapy + '+req.query.therapy_id );
    const reservations= await reservation.find({therapy:req.query.therapy_id}).count();
    
    if(reservations >= 0){
        res.status(200).json(reservations);
    }else{
        res.status(400).json({error:"Error"});
    }
}


export async function VerifReservationUser(req,res){
    console.log('therapy id = '+req.body.therapy_id);
    console.log('patient id = '+req.body.patient_id);
    const reservations=await reservation.find({therapy:req.body.therapy_id,patient:req.body.patient_id}).count();
    if(reservations > 0){
        res.status(200).json({message:"user already reserved"});
    }else{
        res.status(400).json({message:"user not reserved"});
    }
}

export async function cancelReservation(req,res){
    reservation.findOneAndDelete({therapy:req.body.therapy_id,patient:req.body.patient_id},(err,result)=>{
        if(err){
            res.status(400).json(err);
        }else{
            res.status(200).json(-result);
        }
    });
}