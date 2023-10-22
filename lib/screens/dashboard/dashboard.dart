import 'package:flutter/cupertino.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_admin.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_doctor.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_patient.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_user.dart';

class Dashboard extends StatelessWidget{

  final String role;
  const Dashboard({
    Key? key,
    required this.role
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
    
    if(this.role =="user"){
      return const DashboardUser();
    }else{
      if(this.role =="patient"){
        return const DashboardPatient();
      }else{
        if(this.role == "admin"){
          return const DashboardAdmin();
        }else{
          return const DashboardDoctor();
        }
        
      }
    }
  }

}