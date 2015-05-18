import Tkinter
import Tkinter as tk
from Tkinter import *
from tkFileDialog import askopenfilename, asksaveasfilename
from tkMessageBox import askquestion
from os.path import isfile

class MenuCreationError(Exception):
    pass

class SyntaxText(Text):
    '''A text widget that accepts a 'textvariable' option'''
    def __init__(self, *args, **kwargs):
        try:
            self._textvariable = kwargs.pop("textvariable")
        except KeyError:
            self._textvariable = None

        tk.Text.__init__(self, *args, **kwargs)

        # if the variable has data in it, use it to initialize
        # the widget
        if self._textvariable is not None:
            self.insert("1.0", self._textvariable.get())

        # this defines an internal proxy which generates a
        # virtual event whenever text is inserted or deleted
        self.tk.eval('''
            proc widget_proxy {widget widget_command args} {

                # call the real tk widget command with the real args
                set result [uplevel [linsert $args 0 $widget_command]]

                # if the contents changed, generate an event we can bind to
                if {([lindex $args 0] in {insert replace delete})} {
                    event generate $widget <<Change>> -when tail
                }
                # return the result from the real widget command
                return $result
            }
            ''')

        # this replaces the underlying widget with the proxy
        self.tk.eval('''
            rename {widget} _{widget}
            interp alias {{}} ::{widget} {{}} widget_proxy {widget} _{widget}
        '''.format(widget=str(self)))

        # set up a binding to update the variable whenever
        # the widget changes
        self.bind("<<Change>>", self._on_widget_change)

        # set up a trace to update the text widget when the
        # variable changes
        if self._textvariable is not None:
            self._textvariable.trace("wu", self._on_var_change)

    def _on_var_change(self, *args):
        '''Change the text widget when the associated textvariable changes'''

        # only change the widget if something actually
        # changed, otherwise we'll get into an endless
        # loop
        text_current = self.get("1.0", "end-1c")
        var_current = self._textvariable.get()
        if text_current != var_current:
            self.delete("1.0", "end")
            self.insert("1.0", var_current)

    def _on_widget_change(self, event=None):
        '''Change the variable when the widget changes'''
        if self._textvariable is not None:
            self._textvariable.set(self.get("1.0", "end-1c"))
            text = self.get(1.0, 'end-1c') #text_field is a text widget
            s = re.finditer(r'\d+', text)
            for i in s:
                self.tag_add(i, '1.%d' % i.start(), '1.%d' % i.end())
                self.tag_configure(i, foreground='#66D9EF')


class Editor(Frame):
    
    current_file = None
    
    def copy(self):
        all_text = self.text.get('1.0', 'end')
        if all_text != '\n':
            try:
                self.text.clipboard_append(self.text.selection_get())
                self.report('Selection copied to clipboard.')
            except TclError:
                ask = askquestion('Copy all?', 'No text selected.\nWould you like to copy all text?')
                if ask == 'yes':
                    self.text.clipboard_append(all_text)
                    self.report('All text copied to clipboard.')
        else:
            self.report('Nothing to copy.')
    
    def paste(self):
        try:
            self.text.insert(INSERT, self.text.selection_get(selection='CLIPBOARD'))
            self.report('Pasted selection from clipboard.')
        except TclError:
            self.report('Nothing to paste.')
    
    def newFile(self):
        self.current_file = None
        self.text.delete('1.0', 'end')
        
    
    def saveFirst(self, func):
        if self.text.edit_modified():
            if self.saveYN():
                self.saveFile()
        func()
    
    def saveYN(self):
        ask = askquestion('Save changes?', '\nWould you like to\nsave your changes?')
        if ask == 'yes':
            return True
        elif ask == 'no':
            return False
    
    def preOpen(self):
        if self.text.get('1.0', 'end') != '\n':
            if self.saveYN():
                self.saveFile()
        self.openFile()
            
    def importSource(self):
        import http.client
        path = self.path.get()
        if 'http://' in path:
            path = path[7:]
        if '/' in path:
            slash = path.find('/')
            host = path[:slash]
            url = path[slash:]
        else:
            host = path
            url = ''
        connect = http.client.HTTPConnection(host)
        connect.request('GET', url)
        response = connect.getresponse()
        if response.status == 200:
            text = response.read().decode('utf8')
            #for i in range(len(text)):
            self.text.insert('1.0', text)
            self.path.destroy()
            self.submit.destroy()
        
    def openFile(self):
        path = askopenfilename()
        if not path:
            return
        filename = path.split('/')[-1]
        with open(path, mode='r') as f:
            text = f.readlines()
        self.text.delete('1.0', 'end')
        for i in range(len(text)):
            self.text.insert(str(i+1)+'.0', text[i])
        self.report(path+' opened.')
        self.text.edit_modified(False)
        self.current_file = path
        self.master.title(filename+' - Swankedit')
    
    def saveFile(self):
        self.saveAs(self.current_file)
    
    def saveAs(self, cwf=None):
        if cwf:
            path = cwf
        else:
            path = asksaveasfilename()
        if not path:
            return
        filename = path.split('/')[-1]
        with open(path, mode='w') as f:
            f.write(self.text.get('1.0', "end"))
        self.report(path+' saved.')
        self.text.edit_modified(False)
        self.current_file = path
        self.master.title(filename + ' - Swankedit')
            
    def getSourcePage(self):
        self.path = Entry(self)
        self.path.grid(column=1, row=1, columnspan=2, sticky=W+N)
        self.submit = Button(self, text="Submit", command=self.importSource)
        self.submit.grid(column=3, row=1, sticky=W+N)
        
    def createWidgets(self):
        
        # Configure rows and columns
        top = self.winfo_toplevel()
        top.rowconfigure(0, weight=1)
        top.columnconfigure(0, weight=1)
        self.rowconfigure(2, weight=1)
        for i in range(10):
            self.columnconfigure(i, weight=0)
        
        # Create textbox
        self.height = 35
        self.width = 110

        self.textvar = StringVar()
        self.textvar.set("")

        self.text = SyntaxText(self, textvariable=self.textvar, height=self.height, width=self.width, wrap=None, undo=True)
        self.text.configure(background='#272822')
        self.text.configure(foreground='#EEEEEE')
        self.text.configure(highlightcolor='#FF0000')
        self.text.configure(highlightbackground='#272822') #change
        self.text.config(highlightthickness=0)
        self.text.grid(column=0, row=2, columnspan=self.width-1, rowspan=self.height-1, sticky=N+S+E+W)
        self.x_scroll = Scrollbar(self, orient=HORIZONTAL, command=self.text.xview)
        self.x_scroll.grid(column=0, row=self.height+1, columnspan=self.width-1, sticky=W+E)
        self.y_scroll = Scrollbar(self, orient=VERTICAL, command=self.text.yview)
        self.y_scroll.grid(column=self.width, row=2, rowspan=self.height-1, sticky=N+S)
        self.text.config(xscrollcommand=self.x_scroll.set, yscrollcommand=self.y_scroll.set)
        self.radio_ctrlvars = {}
        
        def createMenu(options, toplevel=False, parent=None):
            if toplevel:
                b_column, b_text = toplevel
                button = Menubutton(self, text=b_text)
                button.grid(column=b_column, row=1, columnspan=1, sticky=W+N+E)
                button.menu = Menu(button, tearoff=0)
                button["menu"] = button.menu
                my_menu = button.menu
            else:
                my_menu = parent
            
            for item in options:
                ##############################
                ############### Things removed here
                ##############################
                if item[1] == "radiobutton":
                    try: group = item[3]
                    except IndexError: raise MenuCreationError('Radiobutton "%s" requires additional "group" argument.' % item[0])
                    if not group in self.radio_ctrlvars:
                        self.radio_ctrlvars[group] = StringVar()
                    my_menu.add_radiobutton(label=item[0], command=item[2], variable=self.radio_ctrlvars[group], value=item[0])
                    if len(item) > 4:
                        self.radio_ctrlvars[group].set(item[0])
                else:
                    my_menu.add(item[1], label=item[0], command=item[2])

        
        # File menu
        
        filemenu = (
                    ("New File", "command", lambda:self.saveFirst(self.newFile)),
                    ("Open", "command", lambda:self.saveFirst(self.openFile)),
                    ("Save", "command", self.saveFile),
                    ("Save as...", "command", self.saveAs),
                    ("Import page source", "command", self.getSourcePage),
                    ("Quit", "command", lambda:self.saveFirst(self.quit))
                )
        
        # Edit menu
        
        editmenu = ( 
                    ("Undo", "command", self.text.edit_undo),
                    ("Redo", "command", self.text.edit_redo),
                    ("Copy", "command", self.copy),
                    ("Paste", "command", self.paste)
                )
        ################################################
        #wrapts and viewmenuremoved here
        ################################################
        menu_bar = (
                    ("File", filemenu),
                    ("Edit", editmenu),
                    ####################################
                )
                
        for i in range(len(menu_bar)):
            createMenu(menu_bar[i][1], (i, menu_bar[i][0]))
    
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.master = master
        self.grid(sticky=N+E+S+W)
        self.createWidgets()

root = Tk()
root.title('Swankedit')
app = Editor(master=root)
app.configure(background='#272822')
app.mainloop()