import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn
import os

def create_report():
    doc = Document()
    
    # Page setup - A4
    for section in doc.sections:
        section.page_width = Inches(8.27)
        section.page_height = Inches(11.69)
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)

    # Base styling
    normal_style = doc.styles['Normal']
    normal_style.font.name = 'Arial'
    normal_style.font.size = Pt(12)
    normal_style.font.color.rgb = RGBColor(0, 0, 0)
    normal_style.paragraph_format.line_spacing = 1.15
    normal_style.paragraph_format.space_after = Pt(6)

    def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
        tcPr = cell._tc.get_or_add_tcPr()
        tcMar = OxmlElement('w:tcMar')
        for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
            node = OxmlElement(f'w:{m}')
            node.set(qn('w:w'), str(val))
            node.set(qn('w:type'), 'dxa')
            tcMar.append(node)
        tcPr.append(tcMar)

    def set_cell_shading(cell, color_hex):
        shading = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{color_hex}"/>')
        cell._tc.get_or_add_tcPr().append(shading)

    def set_table_borders(table, color="D3D3D3", sz="4", val="single"):
        tblPr = table._tbl.tblPr
        borders = parse_xml(
            f'<w:tblBorders {nsdecls("w")}>'
            f'<w:top w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'<w:left w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'<w:bottom w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'<w:right w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'<w:insideH w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'<w:insideV w:val="{val}" w:sz="{sz}" w:space="0" w:color="{color}"/>'
            f'</w:tblBorders>'
        )
        tblPr.append(borders)

    def add_code_box(code_text):
        tbl = doc.add_table(rows=1, cols=1)
        tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = tbl.cell(0, 0)
        cell.width = Inches(6.2)
        set_cell_margins(cell, top=120, bottom=120, left=150, right=150)
        set_cell_shading(cell, "F9F9F9")
        
        tcPr = cell._tc.get_or_add_tcPr()
        borders = parse_xml(
            f'<w:tcBorders {nsdecls("w")}>'
            f'<w:top w:val="single" w:sz="6" w:space="0" w:color="000000"/>'
            f'<w:left w:val="single" w:sz="6" w:space="0" w:color="000000"/>'
            f'<w:bottom w:val="single" w:sz="6" w:space="0" w:color="000000"/>'
            f'<w:right w:val="single" w:sz="6" w:space="0" w:color="000000"/>'
            f'</w:tcBorders>'
        )
        tcPr.append(borders)
        
        p = cell.paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        p.paragraph_format.line_spacing = 1.05
        run = p.add_run(code_text.strip())
        run.font.name = 'Consolas'
        run.font.size = Pt(9.5)
        doc.add_paragraph().paragraph_format.space_after = Pt(4)

    # ------------------ PAGE 1: OUTER COVER ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(140)
    if os.path.exists('d:/Ikshita/Bus Reservation/extracted_assets/image1.jpeg'):
        p.add_run().add_picture('d:/Ikshita/Bus Reservation/extracted_assets/image1.jpeg', width=Inches(1.1))

    # Decorative filigree top
    if os.path.exists('d:/Ikshita/Bus Reservation/extracted_assets/image2.png'):
        p_dec = doc.add_paragraph()
        p_dec.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_dec.paragraph_format.space_after = Pt(20)
        p_dec.add_run().add_picture('d:/Ikshita/Bus Reservation/extracted_assets/image2.png', width=Inches(2.2))

    # Framing blue lines
    tbl_title = doc.add_table(rows=1, cols=1)
    tbl_title.alignment = WD_TABLE_ALIGNMENT.CENTER
    c = tbl_title.cell(0, 0)
    c.width = Inches(6.5)
    set_cell_margins(c, top=140, bottom=140, left=100, right=100)
    tcBorders = parse_xml(
        f'<w:tcBorders {nsdecls("w")}>'
        f'<w:top w:val="single" w:sz="24" w:space="0" w:color="4A90E2"/>'
        f'<w:left w:val="none"/>'
        f'<w:bottom w:val="single" w:sz="24" w:space="0" w:color="4A90E2"/>'
        f'<w:right w:val="none"/>'
        f'</w:tcBorders>'
    )
    c._tc.get_or_add_tcPr().append(tcBorders)
    p_main = c.paragraphs[0]
    p_main.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_main = p_main.add_run("JAVA FULL STACK DEVELOPMENT PROJECT REPORT")
    r_main.font.name = 'Arial'
    r_main.font.size = Pt(15)
    r_main.bold = True

    # Decorative filigree bottom
    if os.path.exists('d:/Ikshita/Bus Reservation/extracted_assets/image3.png'):
        p_dec2 = doc.add_paragraph()
        p_dec2.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_dec2.paragraph_format.space_before = Pt(20)
        p_dec2.add_run().add_picture('d:/Ikshita/Bus Reservation/extracted_assets/image3.png', width=Inches(1.3))

    doc.add_page_break()

    # ------------------ PAGE 2: INNER TITLE ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(40)
    r = p.add_run("BUS RESERVATION MANAGEMENT SYSTEM")
    r.font.name = 'Arial'
    r.font.size = Pt(16)
    r.bold = True

    for _ in range(16):
        doc.add_paragraph()

    p_auth = doc.add_paragraph()
    p_auth.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    r1 = p_auth.add_run("Raghulapally Ikshita - 24951A1236\n")
    r2 = p_auth.add_run("Guvvala Likhitha - 24951A1245\n")
    r3 = p_auth.add_run("Potlacheru Neha Sri - 24951A1257")
    for r in [r1, r2, r3]:
        r.font.name = 'Arial'
        r.font.size = Pt(12)
        r.bold = True
        r.italic = True

    doc.add_page_break()

    # ------------------ PAGE 3: SUBMISSION & COLLEGE DETAILS ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("BUS RESERVATION MANAGEMENT SYSTEM\n\n")
    r.font.size = Pt(16)
    r.bold = True

    r_sub = p.add_run("A Project Report\n")
    r_sub.font.size = Pt(13)
    r_sub.italic = True
    r_sub.bold = True

    r_sub2 = p.add_run("submitted in partial fulfilment of the requirement for the award of the degree of\n\n")
    r_sub2.font.size = Pt(11)
    r_sub2.italic = True

    r_deg = p.add_run("Bachelor of Technology\n")
    r_deg.font.size = Pt(13)
    r_deg.bold = True
    r_deg.italic = True

    r_in = p.add_run("in\n")
    r_in.font.size = Pt(12)
    r_in.bold = True
    r_in.italic = True

    r_branch = p.add_run("Information Technology\n\n")
    r_branch.font.size = Pt(13)
    r_branch.bold = True
    r_branch.italic = True

    r_by = p.add_run("by\n\n")
    r_by.font.size = Pt(11)
    r_by.italic = True

    r_studs = p.add_run("Raghulapally Ikshita - 24951A1236\nGuvvala Likhitha - 24951A1245\nPotlacheru Neha Sri - 24951A1257\n\n")
    r_studs.font.size = Pt(12)
    r_studs.bold = True
    r_studs.italic = True

    p_logo = doc.add_paragraph()
    p_logo.alignment = WD_ALIGN_PARAGRAPH.CENTER
    if os.path.exists('d:/Ikshita/Bus Reservation/extracted_assets/image4.jpeg'):
        p_logo.add_run().add_picture('d:/Ikshita/Bus Reservation/extracted_assets/image4.jpeg', width=Inches(1.5))

    p_dept = doc.add_paragraph()
    p_dept.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_dept.paragraph_format.space_before = Pt(10)
    r = p_dept.add_run("Department of Information Technology\n")
    r.font.size = Pt(13)
    r.bold = True
    r = p_dept.add_run("INSTITUTE OF AERONAUTICAL ENGINEERING\n")
    r.font.size = Pt(14)
    r.bold = True
    r = p_dept.add_run("(Autonomous)\nDundigal, Hyderabad – 500 043, Telangana\n")
    r.font.size = Pt(11)
    r.bold = True
    r = p_dept.add_run("October, 2026\n\n")
    r.font.size = Pt(11)
    r.bold = True
    r = p_dept.add_run("© 2026, R.Ikshita, G.Likhitha, P.Neha, All rights reserved.")
    r.font.size = Pt(9.5)

    doc.add_page_break()

    # ------------------ PAGE 4: DECLARATION ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("DECLARATION\n")
    r.font.size = Pt(14)
    r.bold = True

    p_dec = doc.add_paragraph("We certify that\n")
    items = [
        ("a. ", "The work contained in this report is original and has been done by us under the guidance of our supervisor(s)."),
        ("b. ", "The work has not been submitted to any other Institute for any degree or diploma."),
        ("c. ", "We have followed the guidelines provided by the Institute in preparing the report."),
        ("d. ", "We have conformed to the norms and guidelines given in the Ethical Code of Conduct of the Institute."),
        ("e. ", "Whenever we have used materials (data, theoretical analysis, figures, and text) from other sources, we have given due credit to them by citing them in the text of the report and giving their details in the references. Further, we have taken permission from the copyright owners of the sources, whenever necessary.")
    ]
    for prefix, body in items:
        p_item = doc.add_paragraph()
        p_item.paragraph_format.left_indent = Inches(0.4)
        r_pre = p_item.add_run(prefix)
        r_pre.bold = True
        p_item.add_run(body)

    for _ in range(6): doc.add_paragraph()

    tbl_sig = doc.add_table(rows=1, cols=2)
    tbl_sig.alignment = WD_TABLE_ALIGNMENT.CENTER
    c1, c2 = tbl_sig.cell(0, 0), tbl_sig.cell(0, 1)
    c1.width = Inches(3.1)
    c2.width = Inches(3.1)
    p1 = c1.paragraphs[0]
    p1.add_run("Place: Dundigal\nDate:").bold = True
    p2 = c2.paragraphs[0]
    p2.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p2.add_run("Signature of the Student\n24951A1236\n24951A1245\n24951A1257").bold = True

    doc.add_page_break()

    # ------------------ PAGE 5: CERTIFICATE ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("CERTIFICATE\n")
    r.font.size = Pt(14)
    r.bold = True

    p_cert = doc.add_paragraph(
        "This is to certify that the Java Full Stack Development report BUS RESERVATION MANAGEMENT SYSTEM by "
        "RAGHULAPALLY IKSHITA, GUVVALA LIKHITHA, POTLACHERU NEHA SRI, to the Institute of Aeronautical Engineering, "
        "Hyderabad in partial fulfillment of the requirements for the award of the Degree Bachelor of Technology in "
        "Information Technology is a bonafide record of work carried out by them under my guidance and supervision. "
        "The contents of this report, in full or in parts, have not been submitted to any other Institute for the award of any Degree."
    )
    p_cert.paragraph_format.line_spacing = 1.3
    p_cert.paragraph_format.space_before = Pt(14)

    for _ in range(8): doc.add_paragraph()

    tbl_c = doc.add_table(rows=1, cols=2)
    tbl_c.alignment = WD_TABLE_ALIGNMENT.CENTER
    c1, c2 = tbl_c.cell(0, 0), tbl_c.cell(0, 1)
    c1.width = Inches(3.1)
    c2.width = Inches(3.1)
    p1 = c1.paragraphs[0]
    p1.add_run("Supervisor\n\nMs. Dudekula Peeramma").bold = True
    p2 = c2.paragraphs[0]
    p2.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p2.add_run("Head of Department\n\nDr. N. Rajasekhar").bold = True

    doc.add_page_break()

    # ------------------ PAGE 6: APPROVAL SHEET ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("APPROVAL SHEET\n")
    r.font.size = Pt(14)
    r.bold = True

    p_app = doc.add_paragraph(
        "This project report entitled BUS RESERVATION MANAGEMENT SYSTEM by RAGHULAPALLY IKSHITA, "
        "GUVVALA LIKHITHA, POTLACHERU NEHA SRI is approved for the award of the Degree Bachelor of Technology "
        "in Branch Information Technology (IT)."
    )
    p_app.paragraph_format.line_spacing = 1.3
    p_app.paragraph_format.space_before = Pt(14)

    for _ in range(6): doc.add_paragraph()

    tbl_a = doc.add_table(rows=1, cols=2)
    tbl_a.alignment = WD_TABLE_ALIGNMENT.CENTER
    c1, c2 = tbl_a.cell(0, 0), tbl_a.cell(0, 1)
    c1.width = Inches(3.1)
    c2.width = Inches(3.1)
    c1.paragraphs[0].add_run("Examiners").bold = True
    p2 = c2.paragraphs[0]
    p2.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    p2.add_run("Supervisor(s)").bold = True

    for _ in range(4): doc.add_paragraph()

    p_p = doc.add_paragraph()
    p_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_p.add_run("Principal").bold = True

    for _ in range(4): doc.add_paragraph()

    p_d = doc.add_paragraph()
    p_d.add_run("Date:\nPlace: Hyderabad").bold = True

    doc.add_page_break()

    # ------------------ PAGE 7: ACKNOWLEDGEMENT ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("ACKNOWLEDGEMENT\n")
    r.font.size = Pt(14)
    r.bold = True

    doc.add_paragraph(
        "The satisfaction that accompanies the successful completion of any task would be incomplete without "
        "introducing the people who made it possible and whose constant guidance and encouragement crowns all efforts with success."
    )
    doc.add_paragraph(
        "I am extremely grateful and express my profound gratitude and indebtedness to my project guide "
        "Ms. Dudekula Peeramma, Assistant Professor, Department of IT, for the kind help and for giving me the necessary "
        "guidance and valuable suggestions for this project work."
    )
    doc.add_paragraph(
        "I am grateful to Dr. N. Rajasekhar, Head of the Department, Department of Information Technology (IT), "
        "for extending support to carry on this project work. I take this opportunity to express my deepest gratitude to "
        "one and all who directly or indirectly helped me in bringing this effort to present form."
    )

    doc.add_page_break()

    # ------------------ PAGE 8: ABSTRACT ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("ABSTRACT\n")
    r.font.size = Pt(14)
    r.bold = True

    p_ab = doc.add_paragraph(
        "The Bus Reservation Management System is a web-based application designed to simplify and automate the "
        "process of bus ticket booking and reservation management. The system provides a centralized platform through "
        "which passengers can register their accounts, log in securely, search for available buses, view journey details, "
        "check seat availability, and reserve tickets conveniently. It also provides an administrative module for managing "
        "bus information, routes, schedules, fares, seat availability, and passenger reservations. The application is "
        "developed using Java 11, Spring MVC, Hibernate ORM, MySQL, JavaServer Pages (JSP), HTML, CSS, and JavaScript. "
        "Spring MVC manages incoming requests and separates application responsibilities according to the Model-View-Controller "
        "architecture. Hibernate facilitates communication between Java objects and the relational database, while MySQL stores "
        "passenger information, bus details, routes, schedules, seat records, and booking transactions. Apache Tomcat serves as "
        "the application server. The system consists of passenger management, administrator management, bus management, route "
        "management, schedule management, seat management, and reservation management modules. It incorporates user authentication, "
        "input validation, session management, and role-based access control to help protect sensitive information and restrict "
        "unauthorized operations. The proposed system provides a convenient method for passengers to make reservations and allows "
        "administrators to manage transportation information through a centralized interface. It also establishes a foundation for "
        "future enhancements, including online payment integration, electronic ticket generation, email and SMS notifications, "
        "cancellation and refund management, and real-time bus tracking."
    )
    p_ab.paragraph_format.line_spacing = 1.25

    p_kw = doc.add_paragraph()
    p_kw.paragraph_format.space_before = Pt(14)
    r_kw = p_kw.add_run("Keywords: ")
    r_kw.bold = True
    p_kw.add_run("Bus Reservation Management System, Java Full Stack Development, Spring MVC, Hibernate ORM, MySQL, JSP, Online Ticket Booking, Seat Reservation, Bus Management.")

    doc.add_page_break()

    # ------------------ PAGE 9-10: CONTENTS ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("CONTENTS\n")
    r.font.size = Pt(14)
    r.bold = True

    tbl_toc = doc.add_table(rows=0, cols=2)
    tbl_toc.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(tbl_toc, color="000000", sz="4")

    toc_entries = [
        ("Title Page", "I"),
        ("Declaration", "II"),
        ("Certificate", "III"),
        ("Approval Sheet", "IV"),
        ("Acknowledgement", "V"),
        ("Abstract", "VI"),
        ("Contents", "VII"),
        ("List of Figures", "IX"),
        ("Chapter 1: Introduction", "1"),
        ("      1.1 Introduction", "1"),
        ("      1.2 Scope of study", "1"),
        ("      1.3 Technology Stack", "2"),
        ("      1.4 Scope and Limitations", "3"),
        ("Chapter 2: Problem Statement and Proposed Solution", "4"),
        ("      2.1 System Overview", "4"),
        ("      2.2 Problem Analysis", "4"),
        ("      2.3 Proposed Solution", "5"),
        ("      2.4 Benefits and Advantages", "5"),
        ("Chapter 3: System Architecture", "6"),
        ("      3.1 High Level System Design", "6"),
        ("      3.2 System Modules", "7"),
        ("      3.3 Database Design", "8"),
        ("      3.4 Data Flow Architecture", "9"),
        ("      3.5 User Interface Design", "9"),
        ("Chapter 4: Implementation Details", "12"),
        ("      4.1 Technologies and Frameworks Utilized", "12"),
        ("      4.2 Search and Reservation Logic", "12"),
        ("      4.3 Security and Validation", "13"),
        ("      4.4 Deployment", "14"),
        ("Chapter 5: Features and Functionality", "16"),
        ("      5.1 Passenger Module", "16"),
        ("      5.2 Administrator Module", "16"),
        ("      5.3 Registration and Reservation Workflow", "17"),
        ("      5.4 Data Validation and Access Control", "17"),
        ("      5.5 Performance and Maintainability", "18"),
        ("Chapter 6: Output and Results", "19"),
        ("      6.1 Application Interface Demonstrations", "19"),
        ("      6.2 Functional Testing", "20"),
        ("      6.3 Validation and Security Testing", "20"),
        ("      6.4 Results and Discussions", "21"),
        ("Chapter 7: Conclusion and Future Enhancements", "22"),
        ("      7.1 Conclusion", "22"),
        ("      7.2 Future Enhancements", "22"),
        ("Appendix A: Source Code", "24"),
        ("      A.1 Bus Entity Class", "24"),
        ("      A.2 Bus DAO", "25"),
        ("      A.3 Reservation Service", "26"),
        ("References", "27")
    ]

    for item, page_no in toc_entries:
        row = tbl_toc.add_row()
        c0, c1 = row.cells[0], row.cells[1]
        c0.width = Inches(5.2)
        c1.width = Inches(1.0)
        set_cell_margins(c0, top=60, bottom=60, left=100, right=100)
        set_cell_margins(c1, top=60, bottom=60, left=100, right=100)
        p0 = c0.paragraphs[0]
        p0.paragraph_format.space_after = Pt(0)
        r0 = p0.add_run(item)
        if item.startswith("Chapter") or item.startswith("Appendix") or item in ["Title Page", "Declaration", "Certificate", "Approval Sheet", "Acknowledgement", "Abstract", "Contents", "List of Figures", "References"]:
            r0.bold = True
        p1 = c1.paragraphs[0]
        p1.paragraph_format.space_after = Pt(0)
        p1.alignment = WD_ALIGN_PARAGRAPH.RIGHT
        r1 = p1.add_run(page_no)
        if r0.bold: r1.bold = True

    doc.add_page_break()

    # ------------------ PAGE 11: LIST OF FIGURES ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("LIST OF FIGURES\n")
    r.font.size = Pt(14)
    r.bold = True

    tbl_lof = doc.add_table(rows=1, cols=3)
    tbl_lof.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(tbl_lof, color="000000", sz="4")

    # Header
    hdr = tbl_lof.rows[0].cells
    hdr[0].width = Inches(1.2)
    hdr[1].width = Inches(4.2)
    hdr[2].width = Inches(0.8)
    for i, t in enumerate(["Figure", "Title", "Page"]):
        set_cell_margins(hdr[i], top=80, bottom=80, left=100, right=100)
        p = hdr[i].paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        r = p.add_run(t)
        r.bold = True

    fig_entries = [
        ("3.5.1", "Passenger Registration and Sign-In Interface", "10"),
        ("3.5.2", "Intercity Bus Search and Schedule Listing Interface", "10"),
        ("3.5.3", "Interactive Visual Coach Seat Selection Interface", "11"),
        ("3.5.4", "Electronic Boarding Pass / E-Ticket with Barcode Simulation", "11"),
        ("3.5.5", "Executive Administrator Analytics Dashboard", "11")
    ]

    for f_id, f_title, f_page in fig_entries:
        row = tbl_lof.add_row()
        c0, c1, c2 = row.cells[0], row.cells[1], row.cells[2]
        c0.width, c1.width, c2.width = Inches(1.2), Inches(4.2), Inches(0.8)
        for c in [c0, c1, c2]: set_cell_margins(c, top=60, bottom=60, left=100, right=100)
        c0.paragraphs[0].add_run(f_id)
        c1.paragraphs[0].add_run(f_title)
        c2.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.RIGHT
        c2.paragraphs[0].add_run(f_page)

    doc.add_page_break()

    # ------------------ CHAPTER 1: INTRODUCTION ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 1\nINTRODUCTION\n")
    r.font.size = Pt(14)
    r.bold = True

    h1 = doc.add_paragraph()
    h1.add_run("1.1 Introduction:").bold = True
    
    doc.add_paragraph(
        "Transportation plays an important role in connecting people to different cities, towns, educational "
        "institutions, workplaces, and tourist destinations. Bus transportation is one of the commonly used modes of public "
        "transportation because of its accessibility and affordability. As the number of passengers increases, managing bus "
        "schedules, seat availability, passenger details, and ticket reservations becomes more complex."
    )
    doc.add_paragraph(
        "Traditional bus reservation methods may involve visiting ticket counters, contacting booking agents, or maintaining "
        "reservation details manually. These methods can create difficulties such as long waiting times, delays in checking seat "
        "availability, errors in reservation records, and problems in maintaining passenger information. Manual processes can also "
        "make it difficult for administrators to manage multiple buses, routes, schedules, and bookings efficiently."
    )
    doc.add_paragraph(
        "The Bus Reservation Management System is proposed as a web-based application that automates the major activities involved "
        "in bus ticket reservation. It provides a convenient platform where passengers can create accounts, search for buses based "
        "on their source and destination, select suitable travel schedules, check seat availability, and reserve tickets."
    )
    doc.add_paragraph(
        "The system also provides an administrator interface through which authorized users can add and update bus details, "
        "manage routes, configure journey schedules, maintain fare information, and monitor passenger reservations."
    )
    doc.add_paragraph(
        "The application follows a structured architecture that separates the presentation layer, business logic, and database "
        "operations. Java is used to implement application logic, Spring MVC manages web requests, Hibernate handles object-relational "
        "mapping, and MySQL stores application data. JSP, HTML, CSS, and JavaScript are used to develop the user interface."
    )

    h2 = doc.add_paragraph()
    h2.paragraph_format.space_before = Pt(12)
    h2.add_run("1.2 Scope of Study:").bold = True

    doc.add_paragraph("The primary objectives of the project are:")
    objs = [
        "1. To develop a web-based bus reservation application using Java technologies.",
        "2. To provide a registration and login facility for passengers.",
        "3. To enable passengers to search for buses using source, destination, and journey date.",
        "4. To display available buses along with departure time, arrival time, journey duration, and fare.",
        "5. To provide seat availability information for selected bus schedules.",
        "6. To allow passengers to select available seats and create reservations.",
        "7. To maintain passenger details and booking records in a centralized MySQL database.",
        "8. To provide administrators with facilities to manage buses, routes, schedules, fares, and reservations."
    ]
    for o in objs:
        doc.add_paragraph(o)

    doc.add_paragraph(
        "The scope of the Bus Reservation Management System is to develop a web-based application that supports passenger "
        "registration, bus searching, seat selection, ticket booking, and administrative management."
    )

    h3 = doc.add_paragraph()
    h3.paragraph_format.space_before = Pt(12)
    h3.add_run("1.3 Technology Stack:").bold = True

    doc.add_paragraph("The project uses the following technologies.")

    tbl_tech = doc.add_table(rows=1, cols=2)
    tbl_tech.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(tbl_tech, color="000000", sz="4")
    
    hdr = tbl_tech.rows[0].cells
    hdr[0].width = Inches(2.2)
    hdr[1].width = Inches(4.0)
    for i, t in enumerate(["Technology", "Purpose"]):
        set_cell_margins(hdr[i], top=80, bottom=80, left=100, right=100)
        set_cell_shading(hdr[i], "000000")
        p = hdr[i].paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        r = p.add_run(t)
        r.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)

    techs = [
        ("Java SE 11", "Implements application logic and backend functionality."),
        ("Spring MVC 5.3.34", "Handles HTTP requests and organizes the application using MVC architecture."),
        ("Hibernate ORM 5.6.15", "Object-relational mapping and database persistence."),
        ("MySQL 8", "Stores passenger, bus, route, schedule, seat, and booking information."),
        ("JSP 2.3", "Dynamic web page rendering."),
        ("JSTL 1.2", "JSP page tags and presentation logic."),
        ("HTML5 and CSS3", "Page structure and custom responsive styling."),
        ("JavaScript (ES6)", "Client-side interface interactions and live seat map."),
        ("Apache Tomcat 9", "Web application servlet container server."),
        ("Maven 3.9.6", "Dependency management and WAR packaging."),
        ("HikariCP 4.0.3", "High-throughput database connection pooling."),
        ("BCrypt", "Cryptographic salted password hashing."),
        ("JUnit 5 & Mockito", "Automated unit and service testing framework.")
    ]

    for t_name, t_purp in techs:
        row = tbl_tech.add_row()
        c0, c1 = row.cells[0], row.cells[1]
        c0.width, c1.width = Inches(2.2), Inches(4.0)
        set_cell_margins(c0, top=60, bottom=60, left=100, right=100)
        set_cell_margins(c1, top=60, bottom=60, left=100, right=100)
        c0.paragraphs[0].add_run(t_name).bold = True
        c1.paragraphs[0].add_run(t_purp)

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

    h4 = doc.add_paragraph()
    h4.paragraph_format.space_before = Pt(12)
    h4.add_run("1.4 Scope and Limitations").bold = True

    p_sc = doc.add_paragraph()
    p_sc.add_run("Scope\n").bold = True
    p_sc.add_run("The project covers the following areas:")
    sc_items = [
        "● Passenger registration and login.",
        "● Passenger profile management.",
        "● Bus information management.",
        "● Source and destination management.",
        "● Route creation and maintenance.",
        "● Journey schedule management.",
        "● Bus search based on travel details.",
        "● Display of available buses and fares.",
        "● Seat availability checking.",
        "● Seat selection and reservation.",
        "● Booking confirmation and ticket details."
    ]
    for s in sc_items:
        p_item = doc.add_paragraph(s)
        p_item.paragraph_format.space_after = Pt(2)

    p_lim = doc.add_paragraph()
    p_lim.paragraph_format.space_before = Pt(8)
    p_lim.add_run("Limitations\n").bold = True
    p_lim.add_run("The initial version of the Bus Reservation Management System may have certain limitations.")

    lims = [
        ("1. Online Payment: ", "Actual online payment processing requires integration with a secure payment gateway."),
        ("2. Real-Time Bus Tracking: ", "Live location tracking requires GPS devices or integration with an external tracking service."),
        ("3. SMS Notifications: ", "Sending SMS messages requires an appropriate messaging service."),
        ("4. Email Notifications: ", "Automated emails require an email service and suitable configuration."),
        ("5. Refund Processing: ", "Automated refunds require payment gateway integration and additional business logic."),
        ("6. Mobile Application: ", "The web application does not automatically provide a dedicated Android or iOS application."),
        ("7. External Integration: ", "Integration with third-party bus operators or external reservation platforms requires additional development."),
        ("8. Internet Dependency: ", "Users require a suitable network connection to access the online application.")
    ]
    for l_title, l_desc in lims:
        p_l = doc.add_paragraph()
        p_l.paragraph_format.space_after = Pt(3)
        p_l.add_run(l_title).bold = True
        p_l.add_run(l_desc)

    doc.add_paragraph("The system should be tested under appropriate conditions before being deployed for actual commercial use.")

    doc.add_page_break()

    # ------------------ CHAPTER 2: PROBLEM STATEMENT & PROPOSED SOLUTION ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 2\nPROBLEM STATEMENT AND PROPOSED SOLUTION\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("2.1 System Overview:").bold = True

    doc.add_paragraph(
        "A bus reservation process involves maintaining information about buses, routes, journey schedules, fares, "
        "seat availability, passengers, and ticket bookings. When these activities are handled manually or through disconnected "
        "systems, transportation operators may face difficulties in maintaining accurate records and providing timely information "
        "to passengers."
    )
    doc.add_paragraph("The Bus Reservation Management System provides a centralized web-based solution for organizing these activities.")
    doc.add_paragraph("The system consists of two primary user roles: passengers and administrators.")

    p_mod1 = doc.add_paragraph()
    p_mod1.add_run("Passenger Module:\n").bold = True
    p_mod1.add_run("The passenger module enables users to register accounts, log in, search for available buses, view journey details, check seat availability, make reservations, and access their booking information.")

    p_mod2 = doc.add_paragraph()
    p_mod2.add_run("Administrator Module:\n").bold = True
    p_mod2.add_run("The administrator module enables authorized personnel to manage bus details, routes, schedules, fares, seat information, passenger records, and reservations.")

    p_mod3 = doc.add_paragraph()
    p_mod3.add_run("Reservation Management:\n").bold = True
    p_mod3.add_run("The reservation module processes booking requests, records selected seats, generates reservation references, and maintains booking status.")

    p_mod4 = doc.add_paragraph()
    p_mod4.add_run("Database Management:\n").bold = True
    p_mod4.add_run("The database stores the information required for the application and maintains relationships between passengers, buses, routes, schedules, and bookings.")

    doc.add_paragraph("The system aims to provide an organized reservation process that reduces manual effort and improves access to booking information.")

    h_pa = doc.add_paragraph()
    h_pa.paragraph_format.space_before = Pt(12)
    h_pa.add_run("2.2 Problem Analysis:").bold = True

    doc.add_paragraph("Traditional bus reservation methods may depend on manual registers, ticket counters, telephone bookings, or systems that do not share information efficiently.")
    doc.add_paragraph("The application therefore addresses the following issues:")

    probs = [
        ("1. Manual Record Maintenance", "Maintaining passenger details, ticket records, and seat information manually requires considerable administrative effort. Updating records can also introduce errors."),
        ("2. Difficulty in Checking Seat Availability", "Passengers may need to contact booking counters or operators to find out whether seats are available on a particular bus."),
        ("3. Duplicate Reservations", "Without proper seat management and transaction handling, the same seat may accidentally be assigned to more than one passenger."),
        ("4. Time-Consuming Booking Process", "Traditional reservation procedures may require passengers to visit booking counters or contact agents, making the process inconvenient."),
        ("5. Difficulty in Managing Bus Schedules", "Transportation operators must maintain departure times, arrival times, journey dates, routes, and fares. Managing this information manually can become complicated as the number of buses increases."),
        ("6. Data Duplication and Inconsistency", "Passenger details and booking records may be stored in multiple places, leading to inconsistencies and difficulties in retrieving accurate information."),
        ("7. Limited Accessibility", "Passengers may not be able to check bus information or make reservations outside the operating hours of a booking counter."),
        ("8. Reservation Tracking Difficulties", "Retrieving previous bookings, checking cancellation status, and maintaining reservation histories can require additional manual effort."),
        ("9. Security Concerns", "Passenger information and administrative functions must be protected against unauthorized access."),
        ("10. Reporting Difficulties", "Generating information about total reservations, available seats, popular routes, and booking activity may be difficult when records are maintained manually.")
    ]
    for p_title, p_desc in probs:
        p_pr = doc.add_paragraph()
        p_pr.paragraph_format.space_after = Pt(2)
        p_pr.add_run(p_title + "\n").bold = True
        p_pr.add_run(p_desc)

    h_ps = doc.add_paragraph()
    h_ps.paragraph_format.space_before = Pt(12)
    h_ps.add_run("2.3 Proposed Solution:").bold = True

    doc.add_paragraph("The proposed Bus Reservation Management System provides a centralized portal for bus ticketing and transport fleet administration.")
    doc.add_paragraph("The application is divided into functional modules connected through a common database:")

    sol_mods = [
        "1. Passenger Module: Allows passengers to search for buses and manage their reservations.",
        "2. Administrator Module: Provides authorized management operations for buses, routes, schedules, and reservations.",
        "3. Authentication Module: Handles login, logout, and authenticated session access.",
        "4. Bus Management Module: Maintains bus details, routes, seat capacity, and amenities.",
        "5. Schedule Management Module: Manages departure times, arrival times, journey dates, and fares.",
        "6. Reservation Management Module: Supports ticket booking, reservation tracking, and cancellation operations.",
        "7. Seat Management Module: Maintains seat availability, interactive coach layouts, and helps prevent duplicate reservations.",
        "8. Persistence Module: Uses Hibernate and MySQL to store and retrieve application data."
    ]
    for sm in sol_mods:
        doc.add_paragraph(sm)

    doc.add_paragraph(
        "The Spring MVC controllers process user requests and coordinate with service classes. Service classes implement "
        "application operations, DAO classes interact with database records, and JSP pages display information to users."
    )

    h_ba = doc.add_paragraph()
    h_ba.paragraph_format.space_before = Pt(12)
    h_ba.add_run("2.4 Benefits and Advantages").bold = True

    doc.add_paragraph("The proposed system offers the following advantages:")
    advs = [
        "● Centralized storage of passenger, bus, and reservation information.",
        "● Browser-based access to bus reservation services.",
        "● Separate interfaces for passengers and administrators.",
        "● Organized bus route and schedule management.",
        "● Efficient seat availability checking and ticket booking.",
        "● Reduced dependence on manual record maintenance.",
        "● Validation of important user inputs.",
        "● Improved data consistency and reduced booking errors.",
        "● Session-based access to authenticated pages."
    ]
    for a in advs:
        doc.add_paragraph(a)

    doc.add_page_break()

    # ------------------ CHAPTER 3: SYSTEM ARCHITECTURE ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 3\nSYSTEM ARCHITECTURE\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("3.1 High-Level System Design:").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System follows the Model-View-Controller architecture with separate service, "
        "data-access, and persistence responsibilities."
    )
    doc.add_paragraph("The architecture can be represented as follows:")

    p_diag = doc.add_paragraph()
    p_diag.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_diag.paragraph_format.line_spacing = 1.3
    p_diag.add_run("Browser Interface (HTML, CSS, JavaScript, JSP)\n↓\nSpring MVC Controllers\n↓\nService Layer\n↓\nDAO Layer and Hibernate ORM\n↓\nMySQL Database").bold = True

    doc.add_paragraph("Apache Tomcat hosts the web application and provides the servlet container required to process web requests.")

    p_cr = doc.add_paragraph()
    p_cr.add_run("Component Responsibilities\n").bold = True
    p_cr.add_run(
        "Presentation Layer: Displays forms, search results, interactive seat maps, dashboards, and administrative pages.\n"
        "Controller Layer: Receives HTTP requests, validates request parameters, invokes application services, and selects the appropriate JSP view or redirect.\n"
        "Service Layer: The service layer contains business logic for passenger registration, bus searching, seat reservation, booking confirmation, and administrative operations.\n"
        "Data Access Layer: Provides database access through DAO classes.\n"
        "Persistence Layer: Hibernate maps Java entity objects to relational database records.\n"
        "Database Layer: MySQL stores the persistent application data."
    )
    doc.add_paragraph("This layered design improves separation of concerns and makes individual components easier to maintain.")

    h_sm = doc.add_paragraph()
    h_sm.paragraph_format.space_before = Pt(12)
    h_sm.add_run("3.2 System Modules:").bold = True

    p_m1 = doc.add_paragraph()
    p_m1.add_run("3.2.1 Passenger Module\n").bold = True
    p_m1.add_run(
        "The Passenger Module is intended for passengers using the online reservation system. It allows passengers to search "
        "for buses, check seat availability, book tickets, and view reservation details.\n"
        "Passenger records may include passenger ID, full name, email address, phone number, and login credentials. The system "
        "maintains passenger information in the database to support reservation activities."
    )

    p_m2 = doc.add_paragraph()
    p_m2.add_run("3.2.2 Administrator Module\n").bold = True
    p_m2.add_run("The Administrator Module provides management facilities to authorized administrators.\nIts main areas include:\n")
    adm_items = [
        "● Administrator dashboard and summary information.",
        "● Bus record listing and management.",
        "● Route creation and maintenance.",
        "● Schedule creation and maintenance.",
        "● Reservation listing and management.",
        "● Seat availability monitoring.",
        "● Passenger record management."
    ]
    for ai in adm_items: doc.add_paragraph(ai)
    doc.add_paragraph("Administrative operations are protected through authentication and access checks.")

    p_m3 = doc.add_paragraph()
    p_m3.add_run("3.2.3 Authentication Module\n").bold = True
    p_m3.add_run(
        "The Authentication Module manages user access to the application. It validates submitted login credentials, establishes "
        "a session for authenticated users, and supports logout.\n"
        "Session-based authentication can be used to identify logged-in users and restrict access to protected pages. Administrator "
        "functions are accessible only to authorized users."
    )

    p_m4 = doc.add_paragraph()
    p_m4.add_run("3.2.4 Bus, Route, and Schedule Modules\n").bold = True
    p_m4.add_run(
        "The Bus Management Module stores information such as bus number, bus name, bus type, and total seat capacity. The Route "
        "Management Module maintains route information, including starting point, destination, and distance in km.\n"
        "The Schedule Management Module stores journey dates, departure times, arrival times, assigned buses, and ticket fares. "
        "These modules work together to help passengers find suitable buses for their journeys."
    )

    p_m5 = doc.add_paragraph()
    p_m5.add_run("3.2.5 Reservation and Seat Modules\n").bold = True
    p_m5.add_run(
        "The Reservation Management Module handles ticket booking, reservation details, booking history, and cancellation operations.\n"
        "The Seat Management Module maintains seat information and availability for scheduled journeys. It helps prevent duplicate seat "
        "assignments and ensures that reservations are associated with the correct bus and journey."
    )

    h_db = doc.add_paragraph()
    h_db.paragraph_format.space_before = Pt(12)
    h_db.add_run("3.3 Database Design:").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System uses MySQL as its relational database management system. The database stores and "
        "organizes information related to passengers, administrators, buses, routes, schedules, seats, reservations, and booking records."
    )

    db_tables = [
        ("Passengers Table", "The passengers table stores passenger information, such as passenger ID, name, email address, phone number, and account details. Unique constraints are applied to email addresses to prevent duplicate accounts."),
        ("Buses Table", "The buses table stores bus numbers, bus names, bus types, and total seat capacity. Each bus can be associated with one or more schedules."),
        ("Routes Table", "The routes table stores route details, including starting points, destinations, and road distance. It helps organize journeys between different locations."),
        ("Schedules Table", "The schedules table stores journey dates, departure times, arrival times, assigned buses, and ticket fares. It connects bus information with the timing of a particular journey."),
        ("Administrators Table", "The administrators table stores administrator usernames, names, email addresses, password hashes, and account status. Access to administrative functions is restricted to authorized users."),
        ("Seats Table", "The seats table maintains seat numbers and their association with buses or scheduled journeys. Seat availability is updated according to reservation activity."),
        ("Reservations Table", "The reservations table stores booking reference numbers, passenger details, scheduled journey information, selected seats, booking dates, and reservation status.")
    ]
    for t_name, t_desc in db_tables:
        p_t = doc.add_paragraph()
        p_t.add_run(t_name + "\n").bold = True
        p_t.add_run(t_desc)

    p_rel = doc.add_paragraph()
    p_rel.add_run("Database Relationships\n").bold = True
    p_rel.add_run(
        "The database connects passengers with their reservations, buses with their schedules, and schedules with their routes. "
        "Reservation records are associated with the relevant passenger and journey. These relationships help organize information, "
        "maintain consistency, and support efficient retrieval of booking details."
    )

    h_df = doc.add_paragraph()
    h_df.paragraph_format.space_before = Pt(12)
    h_df.add_run("3.4 Data Flow Architecture:").bold = True

    p_df1 = doc.add_paragraph()
    p_df1.add_run("Passenger Registration and Booking Flow\n").bold = True
    df_steps = [
        "1. The passenger opens the application.",
        "2. The passenger registers or logs in to the system.",
        "3. The passenger searches for buses by entering the source, destination, and journey date.",
        "4. The application retrieves matching schedules and available seats.",
        "5. The passenger selects a suitable bus and seat.",
        "6. The application validates the booking details and checks seat availability.",
        "7. The service and data-access layers process the reservation.",
        "8. Hibernate interacts with the MySQL database to store the booking.",
        "9. The application displays the booking confirmation and reservation details."
    ]
    for s in df_steps: doc.add_paragraph(s)

    p_df2 = doc.add_paragraph()
    p_df2.add_run("Authentication Flow\n").bold = True
    auth_steps = [
        "1. The user opens the login page.",
        "2. The user submits the required login credentials.",
        "3. The authentication component verifies the submitted credentials.",
        "4. On successful authentication, the application establishes a session.",
        "5. Protected pages check the session and user permissions.",
        "6. Logout terminates the authenticated session."
    ]
    for s in auth_steps: doc.add_paragraph(s)

    p_df3 = doc.add_paragraph()
    p_df3.add_run("Administrative Workflow\n").bold = True
    adm_steps = [
        "1. The administrator logs in to the system.",
        "2. The application validates the administrator's session and access permissions.",
        "3. The administrator selects a management function.",
        "4. The relevant controller invokes the required service.",
        "5. The service processes the request and applies the required validation.",
        "6. The DAO and Hibernate layers retrieve or update database records.",
        "7. The application displays the result through the appropriate JSP page."
    ]
    for s in adm_steps: doc.add_paragraph(s)

    h_ui = doc.add_paragraph()
    h_ui.paragraph_format.space_before = Pt(12)
    h_ui.add_run("3.5 User Interface Design:").bold = True

    doc.add_paragraph(
        "The application uses JSP, HTML, CSS, and JavaScript to provide browser-based pages. The interface is organized "
        "around passenger-facing pages and administrative pages. Forms are used to collect search and passenger details, while "
        "list and detail pages present stored information."
    )
    doc.add_paragraph("The interface design aims to provide:")
    ui_goals = [
        "● Consistent navigation.",
        "● Clearly labeled input fields.",
        "● Structured forms.",
        "● Readable data tables.",
        "● Responsive page layouts.",
        "● Appropriate feedback after user actions.",
        "● Separate navigation and functions for passenger and administrator roles."
    ]
    for g in ui_goals: doc.add_paragraph(g)

    # Figures 3.5.1 to 3.5.5
    figures = [
        ("d:/Ikshita/Bus Reservation/doc_screenshots/fig1_login.png", "Figure 3.5.1: Passenger Registration and Sign-In Interface"),
        ("d:/Ikshita/Bus Reservation/doc_screenshots/fig2_search_results.png", "Figure 3.5.2: Intercity Bus Search and Schedule Listing Interface"),
        ("d:/Ikshita/Bus Reservation/doc_screenshots/fig3_seat_selection.png", "Figure 3.5.3: Interactive Visual Coach Seat Selection Interface"),
        ("d:/Ikshita/Bus Reservation/doc_screenshots/fig4_ticket.png", "Figure 3.5.4: Electronic Boarding Pass / E-Ticket with Barcode Simulation"),
        ("d:/Ikshita/Bus Reservation/doc_screenshots/fig5_admin_dashboard.png", "Figure 3.5.5: Executive Administrator Analytics Dashboard")
    ]

    for img_path, cap in figures:
        doc.add_paragraph().paragraph_format.space_before = Pt(8)
        p_img = doc.add_paragraph()
        p_img.alignment = WD_ALIGN_PARAGRAPH.CENTER
        if os.path.exists(img_path):
            p_img.add_run().add_picture(img_path, width=Inches(5.6))
        p_cap = doc.add_paragraph()
        p_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_cap.paragraph_format.space_after = Pt(14)
        r = p_cap.add_run(cap)
        r.bold = True
        r.font.size = Pt(10)

    doc.add_page_break()

    # ------------------ CHAPTER 4: IMPLEMENTATION DETAILS ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 4\nIMPLEMENTATION DETAILS\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("4.1 Technologies and Frameworks Utilized:").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System uses Java-based technologies to implement passenger registration, "
        "bus searching, seat selection, reservation processing, and administrative management."
    )
    t_items = [
        "● Java SE 11: Implements the application's business logic.",
        "● Spring MVC 5.3.34: Handles web requests and controllers.",
        "● Hibernate ORM 5.6.15: Manages object-relational mapping.",
        "● MySQL 8: The database maintains relationships between passenger accounts, buses, routes, schedules, seats, and reservations.",
        "● JSP and JSTL: Generate dynamic web pages.",
        "● HTML, CSS, and JavaScript: Build the user interface.",
        "● Apache Tomcat 9: Runs the web application.",
        "● Maven: Manages dependencies and builds the WAR file.",
        "● HikariCP: Manages database connections.",
        "● BCrypt: Provides password hashing."
    ]
    for ti in t_items: doc.add_paragraph(ti)

    h_sr = doc.add_paragraph()
    h_sr.paragraph_format.space_before = Pt(12)
    h_sr.add_run("4.2 Search and Reservation Logic:").bold = True

    doc.add_paragraph(
        "The system supports bus searching, seat reservation, and reservation status management through its DAO and service layers."
    )
    p_ss = doc.add_paragraph()
    p_ss.add_run("Bus Search: ").bold = True
    p_ss.add_run("The BusDao class searches bus records using route filters and criteria.")

    code_bus_search = """public Optional<Bus> findByBusNumber(String busNumber) {
    if (busNumber == null) {
        return Optional.empty();
    }
    List<Bus> list = sessionFactory.getCurrentSession()
            .createQuery("FROM Bus WHERE LOWER(busNumber) = LOWER(:bn)", Bus.class)
            .setParameter("bn", busNumber.trim())
            .getResultList();
    return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
}"""
    add_code_box(code_bus_search)

    p_cr = doc.add_paragraph()
    p_cr.add_run("Seat Reservation: ").bold = True
    p_cr.add_run("The BookingService class checks seat availability, schedule status, and customer account validity.")

    code_booking = """public Booking createBooking(BookingRequestDto request, Long userId) {
    if (request == null || request.getScheduleId() == null) {
        throw new InvalidBookingException("Schedule is required.");
    }
    Schedule schedule = scheduleDao.findByIdForUpdate(request.getScheduleId())
            .orElseThrow(() -> new ResourceNotFoundException("Schedule not found."));
    if (!schedule.isBookable()) {
        throw new InvalidBookingException("This schedule is no longer available.");
    }
    Set<String> alreadyBooked = bookingSeatDao.findBookedSeatNumbers(schedule.getId());
    for (String seatNumber : request.getSeatNumbers()) {
        if (alreadyBooked.contains(seatNumber.trim())) {
            throw new SeatAlreadyBookedException("Seat " + seatNumber + " is already booked.");
        }
    }
    Booking booking = new Booking();
    booking.setBookingReference(BookingReferenceGenerator.generateReference());
    booking.setSchedule(schedule);
    booking.setBookingStatus(Booking.STATUS_CONFIRMED);
    return bookingDao.save(booking);
}"""
    add_code_box(code_booking)

    doc.add_paragraph("The snippet shows the initial validation and pessimistic lock steps of the booking method; the complete method contains additional seat allocation and fare calculations.")

    h_sec = doc.add_paragraph()
    h_sec.paragraph_format.space_before = Pt(12)
    h_sec.add_run("4.3 Security and Validation:").bold = True

    doc.add_paragraph(
        "The application uses session-based authentication, role-based access checks, and input validation to protect "
        "passenger and administrator operations."
    )
    p_iv = doc.add_paragraph()
    p_iv.add_run("Input Validation: ").bold = True
    p_iv.add_run("The validation logic checks email addresses, phone numbers, names, and passwords.")

    code_val = """public static boolean isEmail(String s) {
    return s != null && s.length() <= 100
        && EMAIL_PATTERN.matcher(s.trim()).matches();
}

public static boolean isPhone(String s) {
    return s != null
        && PHONE_PATTERN.matcher(s.trim()).matches();
}"""
    add_code_box(code_val)

    p_ac = doc.add_paragraph()
    p_ac.add_run("Access Control: ").bold = True
    p_ac.add_run("The SecurityInterceptor restricts access to administrative and passenger pages.")

    code_sec = """if (path.startsWith("/admin")) {
    if (currentUser == null) {
        response.sendRedirect(contextPath + "/auth/login?error=login_required");
        return false;
    }
    if (!currentUser.isAdmin()) {
        response.sendRedirect(contextPath + "/auth/login?error=forbidden");
        return false;
    }
    return true;
}"""
    add_code_box(code_sec)

    doc.add_paragraph("The interceptor checks whether authenticated accounts remain active and enforces proper role permissions.")

    h_dep = doc.add_paragraph()
    h_dep.paragraph_format.space_before = Pt(12)
    h_dep.add_run("4.4 Deployment").bold = True

    doc.add_paragraph("The application connects to MySQL using the connection settings defined in application.properties.")
    doc.add_paragraph(
        "The database configuration specifies the JDBC URL, database username, password, and MySQL JDBC driver. "
        "HikariCP provides connection pooling."
    )
    doc.add_paragraph(
        "Hibernate performs the mapping between entity classes and database tables. The supplied configuration deliberately "
        "uses update mode to match the database schema managed by the SQL setup script."
    )
    doc.add_paragraph("The application contains exception-handling components for managing errors and producing appropriate responses.")
    doc.add_paragraph("Typical error conditions include:")
    errs = [
        "● Invalid form data.",
        "● Incorrect login credentials.",
        "● Missing or unavailable records.",
        "● Database connectivity problems.",
        "● Duplicate registration information.",
        "● Unauthorized access attempts.",
        "● Unexpected application errors."
    ]
    for e in errs: doc.add_paragraph(e)

    doc.add_paragraph("The application should communicate failures clearly without exposing passwords, database credentials, or sensitive internal details.")
    doc.add_paragraph("The application uses Maven, MySQL, and Apache Tomcat 9 for deployment.")

    p_ds = doc.add_paragraph()
    p_ds.add_run("Deployment Steps:\n").bold = True
    dep_steps = [
        "1. Install JDK 11, Maven, MySQL 8, and Tomcat 9.",
        "2. Execute resources/sql/schema.sql and data.sql to create the database and tables.",
        "3. Configure database credentials in application.properties.",
        "4. Build the project using:\n    mvn clean package",
        "5. Deploy target/busreservation.war to Tomcat webapps folder.",
        "6. Start Tomcat and verify the database connection.",
        "7. Open the application in a browser using the configured context path, typically http://localhost:8080/ or http://localhost:8080/busreservation/."
    ]
    for ds in dep_steps: doc.add_paragraph(ds)

    doc.add_paragraph("Finally, test passenger registration, login, bus search, seat reservation, and administrator access to verify successful deployment.")

    doc.add_page_break()

    # ------------------ CHAPTER 5: FEATURES AND FUNCTIONALITY ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 5\nFEATURES AND FUNCTIONALITY\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("5.1 Passenger Module").bold = True

    doc.add_paragraph("The Passenger Module provides the passenger-facing part of the reservation portal.")
    doc.add_paragraph("Its principal functions include:")
    p_funcs = [
        "1. Passenger registration and account access.",
        "2. Collection and maintenance of passenger profile information.",
        "3. Display of available bus and journey schedule information.",
        "4. Interaction with the visual seat selection process.",
        "5. Access to relevant passenger portal pages and booking history.",
        "6. Access to e-tickets and printable boarding passes.",
        "7. Session-based access to protected passenger functionality."
    ]
    for pf in p_funcs: doc.add_paragraph(pf)

    doc.add_paragraph("Passenger information is stored in the database and associated with confirmed bookings. The passenger profile includes personal and contact details needed for reservation management.")

    h_am = doc.add_paragraph()
    h_am.paragraph_format.space_before = Pt(12)
    h_am.add_run("5.2 Administrator Module").bold = True

    doc.add_paragraph("The Administrator Module supports the administrative management of reservation information.")

    adm_secs = [
        ("Dashboard", "The dashboard provides an entry point to the administrative functions and displays summary information supported by the dashboard service, including revenue tallies, booking counts, active routes, and fleet utilization."),
        ("Bus Management", "Administrators can manage bus records and use the available fleet management operations, including adding new coaches, updating capacity, and setting amenities."),
        ("Route Management", "Administrators can manage intercity route details, including starting points, destinations, and road distance."),
        ("Schedule Management", "Administrators can manage journey schedules such as departure times, arrival times, dates, assigned buses, and fares."),
        ("Reservation Management", "Administrators can access booking records, inspect reservation details, and manage reservation status using the available administrative functions."),
        ("User Management", "Administrators can review registered customer accounts and administrator profiles.")
    ]
    for s_title, s_desc in adm_secs:
        p_s = doc.add_paragraph()
        p_s.add_run(s_title + "\n").bold = True
        p_s.add_run(s_desc)

    h_rw = doc.add_paragraph()
    h_rw.paragraph_format.space_before = Pt(12)
    h_rw.add_run("5.3 Registration and Reservation Workflow").bold = True

    doc.add_paragraph("The registration workflow organizes the process of collecting passenger details and storing them in the database.")
    rw_steps = [
        "Step 1: Access the portal. The user opens the passenger registration page.",
        "Step 2: Enter information. The user supplies the required personal and contact details.",
        "Step 3: Validate information. The application checks the submitted values and applicable business rules.",
        "Step 4: Process the registration. The application processes the request through the controller and service layers.",
        "Step 5: Store the record. Hibernate persists the information in MySQL.",
        "Step 6: Return feedback. The application displays the appropriate response."
    ]
    for s in rw_steps: doc.add_paragraph(s)

    doc.add_paragraph(
        "The reservation workflow follows a related process in which a passenger interacts with available schedules, selects seats "
        "on the coach map, and the application records the relevant booking information."
    )
    doc.add_paragraph(
        "The precise eligibility rules, status transitions, and capacity restrictions are enforced by the service implementation "
        "and verified through tests."
    )

    h_vd = doc.add_paragraph()
    h_vd.paragraph_format.space_before = Pt(12)
    h_vd.add_run("5.4 Data Validation and Access Control").bold = True

    doc.add_paragraph("Validation helps prevent incomplete, malformed, or inconsistent information from being stored.")
    doc.add_paragraph(
        "The application uses validation utilities and controller/service logic to process submitted information. "
        "Database constraints provide additional safeguards for unique fields and relationships."
    )
    doc.add_paragraph("Examples of important validation checks include:")
    val_checks = [
        "● Required passenger fields.",
        "● Valid email and contact information.",
        "● Valid bus and schedule references.",
        "● Unique bus registration numbers.",
        "● Unique email addresses.",
        "● Appropriate user authentication.",
        "● Authorized access to administrative pages."
    ]
    for vc in val_checks: doc.add_paragraph(vc)

    doc.add_paragraph("Server-side validation is essential because browser-side checks can be bypassed.")

    h_pm = doc.add_paragraph()
    h_pm.paragraph_format.space_before = Pt(12)
    h_pm.add_run("5.5 Performance and Maintainability").bold = True

    doc.add_paragraph("The application uses several design choices to support maintainability and operational efficiency.")
    pms = [
        ("Layered architecture: ", "Separating controllers, services, DAOs, entities, and JSP views makes the code easier to organize."),
        ("Connection pooling: ", "HikariCP manages database connections to reduce the overhead of repeatedly establishing connections."),
        ("Database indexes: ", "The schema defines indexes for selected fields used in record lookup."),
        ("Optimized queries: ", "Hibernate HQL queries retrieve targeted schedules and seats to avoid unnecessary memory overhead."),
        ("Reusable utility classes: ", "Shared validation, web, exception, and session-related functionality is organized into utility components.")
    ]
    for pm_title, pm_desc in pms:
        p_pm = doc.add_paragraph()
        p_pm.add_run(pm_title).bold = True
        p_pm.add_run(pm_desc)

    doc.add_paragraph("These mechanisms provide a basis for maintainable application development. Actual performance must be assessed under representative workloads.")

    doc.add_page_break()

    # ------------------ CHAPTER 6: OUTPUT AND RESULTS ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 6\nOUTPUT AND RESULTS\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("6.1 Application Interface Demonstrations").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System provides a web-based interface designed to simplify bus ticket booking and transport "
        "administration. The application consists of several pages that allow passengers and administrators to perform their respective "
        "operations efficiently. The home page serves as the main entry point and provides navigation to the available portal functions. "
        "The passenger registration page collects essential personal information, such as name, email address, contact number, and password. "
        "The passenger login page enables registered users to access their accounts using valid credentials."
    )
    doc.add_paragraph(
        "The passenger portal provides access to bus schedule search and interactive seat selection. The administrator dashboard serves "
        "as a centralized interface for managing bus fleet records, routes, schedules, fares, and reservations. The bus management page "
        "displays coach details for administrative review, while the route and schedule management pages allow administrators to configure "
        "timetables and dynamic fares. The reservation management page presents passenger booking records and their current status."
    )
    doc.add_paragraph(
        "The application uses JSP, HTML, CSS, and JavaScript to provide an organized and responsive interface. Spring MVC processes user "
        "requests, Hibernate manages database operations, and MySQL stores the application records. Authentication and session-based access "
        "checks help restrict protected pages to authorized users. Together, these interfaces demonstrate how the system supports bus searching, "
        "seat selection, and fleet administration through a centralized web application."
    )

    h_ft = doc.add_paragraph()
    h_ft.paragraph_format.space_before = Pt(12)
    h_ft.add_run("6.2 Functional Testing").bold = True

    doc.add_paragraph("Functional testing verifies whether the application's main features behave as intended.")
    doc.add_paragraph("The following test cases can be used to evaluate the system.")

    tbl_tc = doc.add_table(rows=1, cols=3)
    tbl_tc.alignment = WD_TABLE_ALIGNMENT.CENTER
    set_table_borders(tbl_tc, color="000000", sz="4")

    hdr = tbl_tc.rows[0].cells
    hdr[0].width = Inches(1.0)
    hdr[1].width = Inches(2.6)
    hdr[2].width = Inches(2.6)
    for i, t in enumerate(["Test ID", "Test scenario", "Expected result"]):
        set_cell_margins(hdr[i], top=80, bottom=80, left=100, right=100)
        set_cell_shading(hdr[i], "000000")
        p = hdr[i].paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        r = p.add_run(t)
        r.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)

    test_cases = [
        ("TC01", "Open the home page", "The home page is displayed"),
        ("TC02", "Submit valid passenger registration details", "The registration is processed according to the application rules"),
        ("TC03", "Submit incomplete registration information", "Invalid or incomplete information is rejected where validation applies"),
        ("TC04", "Attempt registration with an existing unique email", "Duplicate information is rejected"),
        ("TC05", "Submit valid login credentials", "The appropriate authenticated session is established"),
        ("TC06", "Submit invalid login credentials", "Authentication is rejected"),
        ("TC07", "Access an administrator page without the required privileges", "Access is denied or redirected"),
        ("TC08", "Create or update a bus record in fleet", "The operation is processed and reflected in the application"),
        ("TC09", "Create or update an intercity route and schedule", "The operation is processed according to the applicable validation rules"),
        ("TC10", "Search for available buses by route and date", "The relevant active schedules and seat counts are displayed"),
        ("TC11", "Select seats and submit a booking request", "Atomic booking is created and unique reference is generated"),
        ("TC12", "Cancel an active passenger booking", "The reservation is cancelled and seats are immediately restored to inventory")
    ]

    for tc_id, tc_sc, tc_exp in test_cases:
        row = tbl_tc.add_row()
        c0, c1, c2 = row.cells[0], row.cells[1], row.cells[2]
        c0.width, c1.width, c2.width = Inches(1.0), Inches(2.6), Inches(2.6)
        for c in [c0, c1, c2]: set_cell_margins(c, top=60, bottom=60, left=100, right=100)
        c0.paragraphs[0].add_run(tc_id).bold = True
        c1.paragraphs[0].add_run(tc_sc)
        c2.paragraphs[0].add_run(tc_exp)

    p_note = doc.add_paragraph()
    p_note.paragraph_format.space_before = Pt(8)
    p_note.add_run("Note: ").bold = True
    p_note.add_run("These are proposed verification scenarios, not claimed test results. After executing the project, fill in the actual result for each test case and record whether it passed or failed.")

    h_vt = doc.add_paragraph()
    h_vt.paragraph_format.space_before = Pt(12)
    h_vt.add_run("6.3 Validation and Security Testing").bold = True

    doc.add_paragraph("The following additional checks are recommended:")
    v_checks = [
        "1. Verify that duplicate bus registration numbers are rejected.",
        "2. Verify that duplicate email addresses are rejected.",
        "3. Verify that invalid form submissions are handled appropriately.",
        "4. Verify that protected pages cannot be accessed without authentication.",
        "5. Verify that passengers cannot perform administrator-only operations.",
        "6. Verify that logout prevents continued use of the previous authenticated session where applicable.",
        "7. Verify that passwords are stored as hashes.",
        "8. Verify that invalid database references are rejected.",
        "9. Verify that errors do not reveal credentials or other sensitive information.",
        "10. Verify that seat booking rules and concurrency locks are enforced by the server."
    ]
    for vc in v_checks: doc.add_paragraph(vc)

    doc.add_paragraph("The results of these checks should be recorded only after running the tests.")

    h_rd = doc.add_paragraph()
    h_rd.paragraph_format.space_before = Pt(12)
    h_rd.add_run("6.4 Results and Discussion").bold = True

    doc.add_paragraph(
        "The project provides a structured web application for bus ticket reservation and fleet administration. Its architecture "
        "separates the user interface, request-processing logic, business operations, and database persistence."
    )
    doc.add_paragraph(
        "The Passenger Module and Administrator Module provide distinct interfaces for their respective users. Spring MVC manages "
        "web requests, Hibernate handles object-relational persistence, and MySQL stores application records."
    )
    doc.add_paragraph(
        "The security-related components provide mechanisms for session-based authentication, role-based access checks, password hashing, "
        "and concurrency protection."
    )
    doc.add_paragraph(
        "The use of Maven, reusable Java classes, and a layered architecture supports organized development and future maintenance."
    )
    doc.add_paragraph(
        "The actual reliability, usability, performance, and correctness of the application should be evaluated using the functional "
        "and security test cases described in this chapter. Quantitative metrics should be added only after measurement."
    )

    doc.add_page_break()

    # ------------------ CHAPTER 7: CONCLUSION & FUTURE ENHANCEMENTS ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("CHAPTER – 7\nCONCLUSION AND FUTURE ENHANCEMENTS\n")
    r.font.size = Pt(14)
    r.bold = True

    h = doc.add_paragraph()
    h.add_run("7.1 Conclusion").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System is a web-based application designed to simplify bus ticket booking and reservation "
        "management. The project provides a structured approach to managing passenger information, bus details, routes, schedules, "
        "seat availability, and booking records."
    )
    doc.add_paragraph(
        "The proposed application uses Java-based web technologies, including Spring MVC, Hibernate ORM, MySQL, JSP, and Apache Tomcat, "
        "to support the development of a centralized reservation platform. The system is divided into passenger and administrator modules. "
        "Passengers can register, log in, search for buses, check available seats, and make reservations. Administrators can manage bus "
        "information, routes, journey schedules, and reservation records through an administrative interface."
    )
    doc.add_paragraph(
        "The database design organizes the information into related tables and supports the association of passengers with their bookings "
        "and journeys. The use of MVC architecture and layered development principles separates the user interface from business logic "
        "and database operations. Input validation, authentication, session management, and authorization checks help protect application "
        "functionality and user information."
    )
    doc.add_paragraph(
        "Overall, the Bus Reservation Management System provides a foundation for managing bus reservations through a centralized web "
        "interface. Further development and testing can extend its functionality and improve its suitability for real-world transportation "
        "requirements."
    )

    h_fe = doc.add_paragraph()
    h_fe.paragraph_format.space_before = Pt(12)
    h_fe.add_run("7.2 Future Enhancements").bold = True

    doc.add_paragraph(
        "The Bus Reservation Management System can be improved in several ways to enhance its functionality, security, and user "
        "experience. The following enhancements can be incorporated into future versions of the application."
    )

    futs = [
        ("Online Payment Integration", "A secure payment gateway can be integrated to allow passengers to pay for reservations through supported payment methods, such as debit cards, credit cards, and online banking."),
        ("Electronic Ticket Generation", "The system can generate downloadable PDF tickets containing the booking reference number, passenger details, journey information, bus details, and selected seats."),
        ("Email Notifications", "Automated email notifications can be implemented to confirm successful bookings, communicate cancellation updates, and provide important journey-related information to passengers."),
        ("SMS Notifications", "SMS functionality can be introduced to send booking confirmations, schedule changes, cancellation updates, and other important notifications directly to passengers' mobile phones."),
        ("Real-Time Bus Tracking", "GPS integration can be implemented to allow passengers to view the approximate current location of buses and obtain updated information about their journeys."),
        ("Automated Cancellation and Refund Management", "The system can be enhanced with configurable cancellation policies, automatic refund calculations, payment gateway integration, and cancellation-status tracking."),
        ("Mobile Application", "A dedicated Android or iOS application can be developed to allow passengers to search for buses, check seat availability, make reservations, and manage their bookings conveniently."),
        ("Multiple Boarding and Dropping Points", "The system can support multiple stops along a route, allowing passengers to select suitable boarding and dropping points according to their travel requirements."),
        ("Discount and Coupon Management", "A discount management module can be introduced to support promotional codes, special offers, and automated fare calculations based on predefined discount rules."),
        ("Reporting and Analytics", "An administrative reporting module can be developed to generate reports on total bookings, popular routes, revenue, cancellations, and seat utilization. These reports can help administrators make informed operational decisions."),
        ("Improved Security", "Additional security measures can be implemented, including secure session management, HTTPS deployment, improved authentication, input validation, and audit logging, to protect user information and prevent unauthorized access.")
    ]
    for f_title, f_desc in futs:
        p_f = doc.add_paragraph()
        p_f.add_run(f_title + "\n").bold = True
        p_f.add_run(f_desc)

    doc.add_paragraph(
        "These enhancements can expand the capabilities of the Bus Reservation Management System, improve passenger satisfaction, "
        "and support future development while maintaining its existing architectural foundation."
    )

    doc.add_page_break()

    # ------------------ APPENDIX A: SOURCE CODE ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run("Appendix A: Source Code\n")
    r.font.size = Pt(14)
    r.bold = True

    doc.add_paragraph(
        "This appendix presents selected source code from the Bus Reservation Management System developed using Java 11, "
        "Spring MVC, Hibernate ORM, and MySQL. The source code illustrates the implementation of bus details, database access, "
        "and ticket reservation functionality."
    )

    p_a1 = doc.add_paragraph()
    p_a1.add_run("A.1 Bus Entity Class\n").bold = True
    p_a1.add_run(
        "The Bus entity represents bus information, including the bus number, bus name, bus type, and seat capacity. "
        "It maps the Java object to the buses database table using Hibernate annotations."
    )

    code_bus_entity = """@Entity
@Table(name = "buses")
public class Bus implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "bus_number", nullable = false, unique = true, length = 50)
    private String busNumber;

    @Column(name = "bus_name", nullable = false, length = 100)
    private String busName;

    @Column(name = "bus_type", nullable = false, length = 50)
    private String busType;

    @Column(name = "total_seats", nullable = false)
    private Integer totalSeats = 32;

    @Column(name = "amenities", length = 255)
    private String amenities;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getBusNumber() { return busNumber; }
    public void setBusNumber(String busNumber) { this.busNumber = busNumber; }
    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }
    public String getBusType() { return busType; }
    public void setBusType(String busType) { this.busType = busType; }
    public Integer getTotalSeats() { return totalSeats; }
    public void setTotalSeats(Integer totalSeats) { this.totalSeats = totalSeats; }
}"""
    add_code_box(code_bus_entity)

    p_a2 = doc.add_paragraph()
    p_a2.add_run("A.2 Bus DAO\n").bold = True
    p_a2.add_run(
        "The Bus Dao class provides database access operations for retrieving bus records using Hibernate. "
        "The following method retrieves active buses from the database."
    )

    code_bus_dao = """@Repository
public class BusDaoImpl implements BusDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Bus save(Bus bus) {
        sessionFactory.getCurrentSession().save(bus);
        return bus;
    }

    @Override
    public Optional<Bus> findById(Long id) {
        Bus bus = sessionFactory.getCurrentSession().get(Bus.class, id);
        return Optional.ofNullable(bus);
    }

    @Override
    public Optional<Bus> findByBusNumber(String busNumber) {
        List<Bus> list = sessionFactory.getCurrentSession()
                .createQuery("FROM Bus WHERE LOWER(busNumber) = LOWER(:bn)", Bus.class)
                .setParameter("bn", busNumber.trim())
                .getResultList();
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    @Override
    public List<Bus> findAllActive() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Bus WHERE isActive = true ORDER BY busName ASC", Bus.class)
                .getResultList();
    }
}"""
    add_code_box(code_bus_dao)

    p_a3 = doc.add_paragraph()
    p_a3.add_run("A.3 Reservation Service\n").bold = True
    p_a3.add_run(
        "The ReservationService class implements the business logic for bus ticket reservations. It uses DAO classes to "
        "retrieve bus information, manage reservations, and access reservation records."
    )

    code_res_service = """@Service
@Transactional
public class BookingServiceImpl implements BookingService {

    @Autowired
    private BookingDao bookingDao;
    @Autowired
    private BookingSeatDao bookingSeatDao;
    @Autowired
    private ScheduleDao scheduleDao;
    @Autowired
    private UserDao userDao;

    @Transactional(readOnly = true)
    public List<Booking> getUserBookings(Long userId) {
        return bookingDao.findByUserId(userId);
    }

    @Transactional(readOnly = true)
    public Optional<Booking> getBookingByReference(String reference) {
        return bookingDao.findByReference(reference);
    }

    public synchronized Booking createBooking(BookingRequestDto request, Long userId) {
        if (request == null || request.getScheduleId() == null) {
            throw new InvalidBookingException("Schedule is required.");
        }
        Schedule schedule = scheduleDao.findByIdForUpdate(request.getScheduleId())
                .orElseThrow(() -> new ResourceNotFoundException("Schedule not found."));
        
        Set<String> alreadyBooked = bookingSeatDao.findBookedSeatNumbers(schedule.getId());
        for (String seatNumber : request.getSeatNumbers()) {
            if (alreadyBooked.contains(seatNumber.trim())) {
                throw new SeatAlreadyBookedException("Seat " + seatNumber + " is already booked.");
            }
        }
        Booking booking = new Booking();
        booking.setBookingReference(BookingReferenceGenerator.generateReference());
        booking.setSchedule(schedule);
        booking.setTotalSeats(request.getSeatNumbers().size());
        booking.setBookingStatus(Booking.STATUS_CONFIRMED);
        return bookingDao.save(booking);
    }
}"""
    add_code_box(code_res_service)

    doc.add_paragraph(
        "These code snippets are illustrative examples for the Bus Reservation Management System. They demonstrate the structure "
        "of the entity, DAO, and service layers. The method names and supporting classes correspond to the actual project implementation. "
        "Imports, additional fields, getters, setters, validation rules, and other methods have been omitted for brevity."
    )

    doc.add_page_break()

    # ------------------ REFERENCES ------------------
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(20)
    r = p.add_run("REFERENCES :\n")
    r.font.size = Pt(14)
    r.bold = True

    refs = [
        "[1] Oracle, “Java Platform, Standard Edition 11 Documentation.” [Online]. Available: https://docs.oracle.com/en/java/javase/11/",
        "[2] VMware, Inc., “Spring Framework Reference Documentation.” [Online]. Available: https://docs.spring.io/spring-framework/reference/",
        "[3] Hibernate, “Hibernate ORM Documentation.” [Online]. Available: https://hibernate.org/orm/documentation/",
        "[4] Oracle, “Java EE 8 Tutorial: JavaServer Pages Technology.” [Online]. Available: https://docs.oracle.com/javaee/8/tutorial/",
        "[5] Oracle, “MySQL 8.0 Reference Manual.” [Online]. Available: https://dev.mysql.com/doc/refman/8.0/en/",
        "[6] Apache Software Foundation, “Apache Tomcat 9 Documentation.” [Online]. Available: https://tomcat.apache.org/tomcat-9.0-doc/",
        "[7] Apache Software Foundation, “Apache Maven Documentation.” [Online]. Available: https://maven.apache.org/guides/",
        "[8] W3C, “HTML5 and CSS3 Specifications.” [Online]. Available: https://www.w3.org/standards/",
        "[9] JUnit Team, “JUnit 5 User Guide.” [Online]. Available: https://junit.org/junit5/docs/current/user-guide/",
        "[10] OWASP Foundation, “OWASP Cheat Sheet Series.” [Online]. Available: https://cheatsheetseries.owasp.org/",
        "[11] Oracle, “JDBC API Documentation for Java Platform, Standard Edition.” [Online]. Available: https://docs.oracle.com/en/java/javase/11/docs/api/java.sql/java/sql/package-summary.html"
    ]
    for ref in refs:
        p_ref = doc.add_paragraph(ref)
        p_ref.paragraph_format.line_spacing = 1.2
        p_ref.paragraph_format.space_after = Pt(8)

    output_path = 'd:/Ikshita/Bus Reservation/My_Project_Report.docx'
    doc.save(output_path)
    print(f"Document successfully created at: {output_path}")

if __name__ == '__main__':
    create_report()
