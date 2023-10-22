import appointement from "../models/Appointement.js";
import user from "../models/user.js"
import schedule from "../models/schedule.js";
import nodemailer from "nodemailer";
import { decrypt, encrypt } from "../utils/Crypto.js"

/***** class user  */
class Appointement{
  constructor(id,user,doctor,role ,date,time,day,upcoming,canceled,statuss) {
    this.id = id;
    this.user = user;
    this.role = role;
    this.doctor = doctor;
    this.date = date;
    this.time = time;
    this.day=day;
    this.upcoming=upcoming;
    this.canceled=canceled;
    this.statuss = statuss;
  
  }
}
/***** end class user */



export async function sendAppointement(req, res) {
  const verifAppointement = await appointement.findOne({ date : req.body.date , user : req.params.id  });
if (verifAppointement) {
    res.status(403).send({ message: "Appointement already exists!" });
} else {
  const appointInvi = new appointement({
          user: req.body.user,
          doctor: req.body.doctor,
          date: req.body.date,
          time: req.body.time,
          day: req.body.day,
          upcoming: true,
          canceled: false,
          statuss : req.body.statuss,     
        
  });  
  await  appointInvi.save();

try {

          res.status(200).send({ message: "Appointement is made", appointInvi });
        } catch (err) {
          console.log(err);
          res.status(500).send({ message: "Error while making an  appointement" });
        }
      }


}

// get all users
// export async function getAppointementsPatient(req, res) {
//   var apps = [];

//   const appointements = await appointement
//     .find({ patient: req.params.id, upcoming: true })
//     .populate("doctor");
  
//   appointements.forEach((element) => {
//     const doctorObj = {
//       fullName: decrypt(element.doctor.fullName),
//       speciality: decrypt(element.doctor.speciality),
//       assurance: decrypt(element.doctor.assurance),
//     };
    
//     const app = new Appointement(
//       element._id,
//       element.patient,
//       doctorObj,
//       element.date,
//       element.time,
//       element.day,
//       element.upcoming,
//       element.canceled,
//       element.statuss
//     );
    
//     apps.push(app);
//   });

//   if (appointements) {
//     res.status(200).json({ apps });
//   } else {
//     res.status(403).send({ message: "Fail : No Appointements" });
//   }
// };

export async function getAppointementsUser(req, res) {
  console.log('get apointment user id '+req.params.id);
  var apps = [];

  const appointements = await appointement
    .find({ user: req.params.id, upcoming: true })
    .populate("doctor");
  
  appointements.forEach((element) => {
    const doctorObj = {
      fullName: decrypt(element.doctor.fullName),
      speciality: decrypt(element.doctor.speciality),
      assurance: decrypt(element.doctor.assurance),
    };
    
    //id,user,doctor,role ,date,time,day,upcoming,canceled,statuss
    const app = new Appointement(
      element._id,
      element.user,
      doctorObj,
      element.role,
      element.date,
      element.time,
      element.day,
      element.upcoming,
      element.canceled,
      element.statuss
    );
    
    apps.push(app);
  });

  if (appointements) {
    res.status(200).json({ apps });
  } else {
    res.status(403).send({ message: "Fail : No Appointements" });
  }
};

//get all users 
export async function getAppointementsDoctor(req, res) {
  var appss = [];
  const appointements = await appointement.find({doctor : req.params.id, statuss: "pending"}).populate("user").sort({_id:-1});

  appointements.forEach((element) => {
    const userObj = {
      nicknName: decrypt(element.user.nicknName),
      phone: decrypt(element.user.phone),
      fullName: decrypt(element.user.fullName),
      id: element.user._id,
      role: decrypt(element.user.role)
    };
    console.log(userObj);
    const app = new Appointement(
      element._id,
      userObj,
      element.doctor,
      element.role,
      element.date,
      element.time,
      element.day,
      element.upcoming,
      element.canceled,
      element.statuss
    );
    
    appss.push(app);
  });

  if (appointements) {
    res.status(200).json({ appss });
  } else {
    res.status(403).send({ message: "Fail : No Appointements" });
  }
};

export async function getAppointementsDoctorApprouved(req, res) {
  var ap = [];
  const appointements = await appointement.find({doctor : req.params.id, statuss: "approuved"}).populate("user").sort({_id: -1});

  appointements.forEach((element) => {
    const userObj = {
      nicknName: decrypt(element.user.nicknName),
      phone: decrypt(element.user.phone),
      fullName: decrypt(element.user.fullName),
      id: element.user._id,
      role: decrypt(element.user.role),
    };
    
    const app = new Appointement(
      element._id,
      userObj,
      element.doctor,
      element.role,
      element.date,
      element.time,
      element.day,
      element.upcoming,
      element.canceled,
      element.statuss
    );
    
    ap.push(app);
  });

  if (appointements) {
    res.status(200).json({ ap });
  } else {
    res.status(403).send({ message: "Fail : No Appointements" });
  }
};



// export async function getAppointementsDoctorPatient(req, res) {
//   var appss = [];
//   const appointements = await appointement.find({doctor : req.params.id, statuss: "pending"}).populate("patient");

//   appointements.forEach((element) => {
//     const patientObj = {
//       nicknName: decrypt(element.patient.nicknName),
//       phone: decrypt(element.patient.phone),
//       fullName: decrypt(element.patient.fullName),
//     };
    
//     const app = new Appointement(
//       element._id,
//       patientObj,
//       element.doctor,
//       element.date,
//       element.time,
//       element.day,
//       element.upcoming,
//       element.canceled,
//       element.statuss
//     );
    
//     appss.push(app);
//   });

//   if (appointements) {
//     res.status(200).json({ appss });
//   } else {
//     res.status(403).send({ message: "Fail : No Appointements" });
//   }
// };

//approuve appointement
export async function approuveAppointement(req, res) {

  const approuveApp = await appointement.findOneAndUpdate({ _id: req.body._id },
      {
          statuss : "approuved"
       },
  );
  res.status(200).send({ message: "Accepted with success", approuveApp: approuveApp });

  
}

//cancel appointement
export async function cancelAppointement(req, res) {

  const canceledApp = await appointement.findOneAndUpdate({ _id: req.body._id },
      {
          statuss : "canceled"
       },
  );
  const app=await appointement.findOne({_id: req.body._id}).populate('user');
  const email = decrypt(app.user.email);
  const transporter = nodemailer.createTransport({
    service:"gmail",
    auth: {
     user: process.env.EMAIL, //REPLACE WITH YOUR EMAIL ADDRESS
     pass: process.env.KEY_GMAIL //REPLACE WITH YOUR EMAIL PASSWORD
     },
    });

    let info = transporter.sendMail({
        from: "hamza.nechi@esprit.tn",
        to:email,
        subject:"Appointment Status",
        // text:"Your room name is hza",
        html:"<html><center><h1>The doctor has canceled your appointment</h1></center></html>"
    });

    transporter.sendMail(info, function (error, info) {
        console.log("mail scheduler sended");
    });
  res.status(200).send({ message: "Canceled with success", canceledApp: canceledApp });

  
}


//confirm appointement
export async function confirmPatient(req, res) {

  user.findOneAndUpdate({_id :req.body._id},{role : encrypt("patient")})
  .then(doc => {
    res.status(200).send({ message: "Accepted with success", confirmPatient: doc })
    console.log(doc)
  }).catch(error => {
    console.log(error)
  });
}