import {Controller} from "@hotwired/stimulus"
import $ from "jquery";

// Connects to data-controller="image-preview"
export default class extends Controller {
    static targets = ["input", "preview"];

    connect() {
        let preview = this.previewTarget;
        if (preview.src !== undefined) {
            if (!preview.src.includes('media_galery_todos') && !preview.src.includes('active_storage')) {
                preview.src = '/unknown.webp'
            }
        }
    }

    preview() {
        let input = this.inputTarget;
        let preview = this.previewTarget;
        let file = input.files[0];
        let reader = new FileReader();

        reader.onloadend = () => {
            preview.src = reader.result;
        }

        if (file) {
            reader.readAsDataURL(file);
        } else {
            preview.src = "";
        }
    }

    previewAll() {
        let input = this.inputTarget;
        let preview = this.previewTarget.parentNode;
        let file = input.files[0];
        let reader = new FileReader();

        reader.onload = event => {
            let fileType = event.target.result.split(";")[0].split(":")[1];
            let element;

            if (fileType.includes("image")) {
                element = document.createElement("img");
                element.className = "media-upload media-upload-normal";
                element.setAttribute('data-image-preview-target', 'preview');
            } else if (fileType.includes("audio")) {
                element = document.createElement("audio");
                element.controls = true;
                element.autoplay = false;
                element.id = 'media_galery_repro_';
                element.setAttribute('data-image-preview-target', 'preview');
                element.className = "media-upload media-upload-audio";
            } else if (fileType.includes("video")) {
                element = document.createElement("video");
                element.controls = true;
                element.autoplay = false;
                element.id = 'media_galery_repro_';
                element.setAttribute('data-image-preview-target', 'preview');
                element.className = "media-upload media-upload-normal";
            } else {
                // Manejar otros tipos de archivos
                element = undefined;
            }

            if (element !== undefined) {
                element.style.width = "100%";
                element.src = event.target.result;
                preview.innerHTML = '';
                preview.appendChild(element);
            } else {
                if (fileType.includes("android")) {
                    preview.innerHTML = `<svg data-image-preview-target="preview" xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-brand-android" width="100" height="100" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                            <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                            <line x1="4" y1="10" x2="4" y2="16"></line>
                                            <line x1="20" y1="10" x2="20" y2="16"></line>
                                            <path d="M7 9h10v8a1 1 0 0 1 -1 1h-8a1 1 0 0 1 -1 -1v-8a5 5 0 0 1 10 0"></path>
                                            <line x1="8" y1="3" x2="9" y2="5"></line>
                                            <line x1="16" y1="3" x2="15" y2="5"></line>
                                            <line x1="9" y1="18" x2="9" y2="21"></line>
                                            <line x1="15" y1="18" x2="15" y2="21"></line>
                                        </svg>`;
                } else {
                    preview.innerHTML = '<svg data-image-preview-target="preview" xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-file-description" width="100" height="100" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">\n' +
                        '   <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>\n' +
                        '   <path d="M14 3v4a1 1 0 0 0 1 1h4"></path>\n' +
                        '   <path d="M17 21h-10a2 2 0 0 1 -2 -2v-14a2 2 0 0 1 2 -2h7l5 5v11a2 2 0 0 1 -2 2z"></path>\n' +
                        '   <path d="M9 17h6"></path>\n' +
                        '   <path d="M9 13h6"></path>\n' +
                        '</svg>';
                }
            }
        };

        if (file) {
            $("#media_galery_name").val(file.name);
            $("#media_galery_mime_type").val(file.type);
            $("#media_galery_size").val(file.size);
            $("#media_galery_extension").val("." + file.name.split('.').pop());

            reader.readAsDataURL(file);
        }
    }

    loadInputFile(e) {
        $(`#${e.target.dataset.id}`).click();
    }
}
