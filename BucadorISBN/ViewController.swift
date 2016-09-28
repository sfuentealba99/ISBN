//
//  ViewController.swift
//  BucadorISBN
//
//  Created by Sergio Fuentealba on 24-09-16.
//  Copyright © 2016 Sergio Fuentealba. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var botLimpiar: UIButton!
    @IBOutlet weak var isbnResultadoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        isbnTextField.delegate=self
        
        //Aunque se indique que le clear button este visible siempre no aparecerá si el campo de texto esta vacío ya que no hay nada que borrar.
        isbnTextField.clearButtonMode = UITextFieldViewMode.always
        isbnTextField.text = "Que ISBN deseas buscar?"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func textFieldDoneEditing(_ sender:UITextField){
        //Desaparece el teclado al presionar INTRO/SEARCH/etc
        sender.resignFirstResponder()
        sincrono ()
    }
    
    @IBAction func backgroundTap(_ sender:UIControl){
        //Desaparece el teclado cuando toco fuera del campo
        isbnTextField.resignFirstResponder()
    }
    
    @IBAction func buscarISBN(_ sender: AnyObject) {
        sincrono ()
    }
    
    @IBAction func limpiarCampos(_ sender: AnyObject) {
        isbnTextField.text = ""
        isbnResultadoTextView.text = ""
    }
    
    func sincrono (){
        //el isbn a capturar
        var isbnBuscar = isbnTextField.text!
        if isbnBuscar == "Que ISBN deseas buscar?"
        {
            isbnBuscar = ""
        }
        //creo la url
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = URL(string: urls+isbnBuscar)
        let datos : Data? =  try? Data (contentsOf: url!)
        
        //valido conexion a internet y si la peticion vuelve vacía porque no encontró el isbn que buscamos -> {}
        if datos == nil{
            
            errorAlert("Error en la conexion", mensaje: "Hay un problema con tu conexión a internet. Por favor  intenta de nuevo.")
            
        }else {
            
            let texto = NSString(data:datos!, encoding:String.Encoding.utf8.rawValue)
            //print(texto)
            
            if texto != "{}"{
                
                self.isbnResultadoTextView.text = texto! as String
                
            }else{
                
                self.errorAlert("Error en el ISBN", mensaje: "No se encontró un libro asociado al ISBN:\(isbnBuscar) ingresado. Intenta otro ISBN.\n\nGracias!")
                
            }
            
        }
        
    }
    
    func errorAlert (_ error: String, mensaje: String) {
        let alert: UIAlertController = UIAlertController(title: error, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        isbnResultadoTextView.text = mensaje
    }
    
    
}
