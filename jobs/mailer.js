
import nodemailer from 'nodemailer';
import user from '../models/user.js';
import { decrypt } from '../utils/Crypto.js';

// * * * * * *
//   | | | | | |
//   | | | | | day of week
//   | | | | month
//   | | | day of month
//   | | hour
//   | minute
//   second ( optional )

async function getEmails(){
    var emails=[];
    const users= await user.find().lean();
    for(const usr of users){
        emails.push(decrypt(usr.email));
    }
    return "hamza nechi";
}

async function main() {
//     console.log('send mail function started');
//     const transporter = nodemailer.createTransport({
//       service:"gmail",
//       auth: {
//        user: process.env.EMAIL, //REPLACE WITH YOUR EMAIL ADDRESS
//        pass: process.env.KEY_GMAIL //REPLACE WITH YOUR EMAIL PASSWORD
//        },
//    });
  
//    //const emails = await getEmails();
   
//    let info = transporter.sendMail({
//        from: "hamza.nechi@esprit.tn",
//        to:"nechihamza114@gmail.com",
//        subject:"Dear Self-Schedular",
//       // text:"Your room name is hza",
//        html:"<html><center><h1>Response</h1><br><p>Schedular 60%</p></center></html>"
//    });

//    transporter.sendMail(info, function (error, info) {
//        console.log("mail scheduler sended");
//    });
    
}

main()//.catch(err => console.log(err));