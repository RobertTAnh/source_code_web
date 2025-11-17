// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./admin_add_jquery"
import * as bootstrap from "bootstrap"
import toastr from "toastr";
window.toastr = toastr;
import "./extra"
import "ckeditor4/ckeditor";
import "@fortawesome/fontawesome-free/js/all"
import "../../vendor/admin-lte/dist/js/adminlte";
import "./dashboard"
import "./post"
import "./application"
import "dropify/src/js/dropify";
import "./ckeditor_javascript";
import "gijgo/js/gijgo"
import JSONEditor from "jsoneditor/dist/jsoneditor";
window.JSONEditor = JSONEditor;
import select2 from "select2/dist/js/select2";
// TODO: check why need to call select2() here
select2();
import Dropzone from 'dropzone/dist/dropzone-min';

toastr.options = {    
  "closeButton": true,    
  "debug": false,    
  "newestOnTop": true,    
  "progressBar": true,    
  "positionClass": "toast-top-right",    
  "preventDuplicates": false,    
  "onclick": null,    
  "showDuration": "300",    
  "hideDuration": "1000",    
  "timeOut": "4000",    
  "extendedTimeOut": "2000",    
  "showEasing": "swing",    
  "hideEasing": "linear",    
  "showMethod": "fadeIn",    
  "hideMethod": "fadeOut"    
}
