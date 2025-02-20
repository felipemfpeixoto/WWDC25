//
//  File.swift
//  My App
//
//  Created by Felipe on 09/02/25.
//

import Foundation

class FalasManager {
    
    static var shared: FalasManager = FalasManager()
    private init() {}
    
    let falasOnBoarding: [String] = [
        "Hey  there ,  explorer !\nI'm  Zico ,  a curious puppy with a big heart... and no sight !",
        "Right  now ,  I'm  in  the  hospital . \nMy  family  sent  me  a  message  but ...  I  can't  read  it.",
        "They  wrote  it  in  Braille !\n I  can  feel  it ,  but  I  need  your  help  to  understand .",
        "Will  you  help  me  decode  their  message ?\nI  really  want  to  know  what  they  sent me !",
        "REALLY ?! GREAT !!!\nLet's  jump  in  then !"
    ]
    
    let falasMenuOne: [String] = [
        "This  is  the  message  my  family  sent  to  me .",
        "For  now ,  we  can't  understand  the\ncharacters  properly .",
        "Let's  start  lesson  one  and  improve  our  skills !!!",
        "Maybe  this  will  help  us  understand\na  little more  of  the  message !"
    ]
    
    let falasLessonOne: [String] = [
        "In  this  first  lesson ,  we'll  learn  how\nthe  Braille  dots  are  organized .",
        "Braille  is  made  up  of  tiny  dots  arranged\nin  a  cell  with  six  possible  spots .",
        "It's  like  a  domino  standing  up !",
        "We  number  the  dots  like  this :\n1  to  3  (first  column)  4  to  6  (second  column)",
        "With  just  these  six  dots ,  we  can  create\nover  60  different  symbols !",
        "Now ,  tap  random  dots  and  see  the  symbols\nthey  form  together !",
        "REMEMBER !!!  We  only  have  26  letters\nin  the  alphabet ...",
        "So ,  not  every  combination  of  dots  will\nresult  in  a  valid  character !"
    ]
    
    let falasMenuTwo: [String] = [
        "WOW !!!",
        "Now  we  can  see  the  representation\nfor  the  characters  in  the  message !",
        "Let's  keep  going ,  and  see  if  we\ncan  discover  the  characters  !"
    ]
    
    let falasLessonTwo: [String] = [
        "Now ,  we'll  learn  the  representation  for\nthe  characters  from  A  to  J .",
        "These  characters  use  only  the  top  4  dots\nto  be  represented .",
        "The  understanding  of  these  characters  is\nkey  to  understand  the  rest  of  the  alphabet .",
        "We'll  talk  more  about  it  on  Lesson  3 !",
        "Click  on  the  characters  to  see  their\nrepresentation  on  the  dots .",
        "You  can  also  click  on  the  dots  to  see\nwhich  character  they  represent  together ."
    ]
    
    let falasMenuThree: [String] = [
        "LOOK !",
        "Now  we  can  see  some  of\nthe  message's  characters !",
        "Let's  keep  going  to  discover\nmore  secret  characters !!!"
    ]
    
    let falasLessonThree: [String] = [
        "Now ,  we'll  learn  the  representation\nfor the  characters  from  K to  Z ...",
        "They  work  exactly  like  the  past  characters ,\nbut  with  the  dots  3  and  6  activated .",
        "Let's  take  the  representation  for  the\nletter  K ,  for  example :",
        "Can  you  see  a  pattern  here  ?",
        "It's  the  same  representation  as  the\nletter  A ,  but  with  the  dot  3  activated !!!",
        "Now ,  the  only  letter  that  doesn't  follow\nthis  pattern  is  the  W .",
        "That  happens  because  Braille  was\ninvented  in  France  in  1824 ...",
        "And  the  French  language  didn't  use\nthe  letter  W  at  that  time !",
        "Now  it's  up  to  you !",
        "Explore  the  other  representations\nbefore  moving  on !"
    ]
    
    let falasCompleted: [String] = [
        "WE  GOT  IT !",
        "My  family  left  me  this  message ,\nI  love  them  so  much !",
        "I  definetly  feel  stronger  to  get  better\nand  come  back  to  them  now !",
        "Thanks  for  your  help ,\nI  couldn 't  have  done  this  alone !"
    ]
    
    func getFalas(for router: Router) -> [String] {
        switch router {
        case .onBoarding:
            return falasOnBoarding
        case .menu:
            return falasMenuOne
        case .lessonOne:
            return falasLessonOne
        case .menu2:
            return falasMenuTwo
        case .lessonTwo:
            return falasLessonTwo
        case .menu3:
            return falasMenuThree
        case .lessonThree:
            return falasLessonThree
        case .completed:
            return falasCompleted
        }
    }
}
