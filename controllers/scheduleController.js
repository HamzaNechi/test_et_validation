import user from "../models/user.js"
import schedule from "../models/Schedule.js";

export async function addWorkingHours(req, res) {
  const verifSchedule = await schedule.findOne({ user : req.params.id }).count();
  if (verifSchedule > 7) {
      res.status(403).send({ message: "Schedule of this day already exists!" });
  } else {
      
    const userDoc = await user.findOne({ _id: req.params.id });
     
    
      const newSchedule = new schedule();
      newSchedule.dayOfWeek = req.body.dayOfWeek;
      newSchedule.startTime = req.body.startTime;
      newSchedule.endTime = req.body.endTime;
      newSchedule.user = req.params.id;
      newSchedule.save();
      

      userDoc.schedules.push(newSchedule._id);
      userDoc.save();
      console.log("user", newSchedule.user)
      res.status(201).send({schedule: newSchedule});

  }
};

export async function getSchedule(req,res){
  const scheduleuser = await user.findOne({  user : req.params._id }).populate("schedules")
 
  if (scheduleuser) {
    res.status(200).json(scheduleuser.schedules)
  } else {
      res.status(403).send({ message: "fail" });
  }
}

export async function getUserWithSchedule(req,res){
  const scheduleuser= await schedule.find({user :req.params._id }).populate('user');
 
  if (scheduleuser) {
    res.status(200).json(scheduleuser)
  } else {
      res.status(403).send({ message: "fail" });
  }
}