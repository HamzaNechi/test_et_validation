
import { validationResult } from 'express-validator';
import isEmail from 'validator/lib/isEmail.js';
import therapy from '../models/therapy.js';
import user from '../models/user.js';



export function getAll(req, res) {
    therapy
        .find({}).sort({_id:-1})
        .then(docs => {
            res.status(200).json(docs);
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });

}


export function getDash(req, res) {
    therapy
        .find({})
        .limit(8).sort({_id:-1})
        .then(docs => {
            res.status(200).json(docs);
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });

}


export function addOnce(req, res) {
    console.log("room name : "+req.body.code);
    const id_user = req.params.idUser;
    console.log("id  ========= ",id_user);
    if (!id_user) {
        return res.status(401).json({ error: "User ID is missing." });
    }
    if (!validationResult(req).isEmpty()) {
        return res.status(402).json({ errors: validationResult(req).array() });
    }
    const capacity = req.body.capacity;
    if (isNaN(capacity)) {
    return res.status(403).json({ error: "Capacity must be a number." });
    }

   // const us=user.findById(id_user);
    
    console.log(req.file)
        therapy
            .create({
                titre: req.body.titre,
                date: req.body.date,
                address: req.body.address,
                type:req.body.type,
                capacity: req.body.capacity,
                dispo: req.body.dispo,
                description : req.body.description,
                code:req.body.code,
                user : id_user.trim(),
                image: `${req.protocol}://${req.get('host')}/image/${req.file.filename}`
                
            })
            .then(newTherapy => {
                res.status(201).send({ therapy: newTherapy });
            })
            .catch(err => {
                console.error(err);
                console.log(image)
                res.status(500).json({ error: err });
            });
            
//     }).catch(err => res.status(404).json({ error: "user not found!" }))
// }

        }

export function getOnce(req, res) {
    console.log(req.params.idUser)
    therapy
        .findOne({ user: req.params.idUser })
        .then(doc => {
            res.status(200).json([doc]);
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });
}

export function putAll(req, res) {
    therapy
        .updateMany({}, { "dispo": true })
        .then(doc => {
            res.status(200).json(doc);
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });
}


export async function updateT(req, res) {

  
    if (!validationResult(req).isEmpty()) {
        return res.status(400).json({ errors: validationResult(req).array() });
    }
    else{

        therapy
            .create({
                titre: req.body.titre,
                date: req.body.date,
                address: req.body.address,    
            })
            .then(newTherapy => {
                res.status(201).send({ therapy: newTherapy });
            })
            .catch(err => {
                console.error(err);
                res.status(500).json({ error: err });
            });
    }


};


export function deleteOnce(req, res) {
    console.log("deleteeeeee")
    therapy
        .findById(req.params.id)
        .deleteOne()
        .then((doc) => {
            res.status(200).json(doc)
        })
        .catch((err) => {
            res.status(500).json({ error: err })
        })
}

export async function getTherapyByTitle(req, res) {
    const titre = req.params.titre.trim()
    console.log(`titre: ${titre}`)
    const regex = new RegExp(titre, 'i')
    const therapies = await therapy.find({ titre: regex })
    console.log(`therapies: ${therapies}`)
    if (therapies.length > 0) {
        res.status(200).json(therapies)
    } else {
        res.status(404).send({
            message: `No therapies found with title containing '${titre}'`,
        })
    }
}

export async function patchOnce(req, res) {
    const filter={
        _id:req.params.id
    };

    var update={};

    if(req.file == undefined){
        //hné mé tbaddalech image
        if(req.body.type == "face-to-face"){
            update = { 
                titre: req.body.titre,
                date: req.body.date,
                address: req.body.address,
                description: req.body.description,
                capacity: req.body.capacity,
                type: "face-to-face",
            };
        }else{
            update = { 
                titre: req.body.titre,
                date: req.body.date,
                address: "",
                description: req.body.description,
                capacity: req.body.capacity,
                code: req.body.code,
                type: "Remotely",
            };
        }
    }else{
        //hné tbaddel image
        if(req.body.type == "face-to-face"){
            update = { 
                titre: req.body.titre,
                date: req.body.date,
                address: req.body.address,
                description: req.body.description,
                capacity: req.body.capacity,
                type: "face-to-face",
                image: `${req.protocol}://${req.get('host')}/image/${req.file.filename}`
            };
        }else{
            update = { 
                titre: req.body.titre,
                date: req.body.date,
                address: "",
                description: req.body.description,
                capacity: req.body.capacity,
                code: req.body.code,
                type: "Remotely",
                image: `${req.protocol}://${req.get('host')}/image/${req.file.filename}`
            };
        }
    }
    
    


    await therapy
      .findOneAndUpdate(filter,update)
      .then((newTherapy) => {
        res.status(200).send({ therapy: newTherapy });
        console.log(req.params.id);
      })
      .catch((err) => {
        res.status(500).json({ error: err });
      });
  }