/* 数据流接收  如果打的包数据已经完整，这Terminate不为空，否则Terminate为空 */

// 有头有尾，报文中没有和头一样的字符，长度不固定
QByteArray recvDataFlow(QByteArray recvMsg)
{
    QByteArray Terminate; Terminate.clear();
    if( -1 != m_storeNow.indexOf("$") ){ // 现在打的包有头了
        
        if(-1 != recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ //含有$，且含有#
            int n = recvMsg.indexOf("$");
            int m = recvMsg.indexOf("#");
            
            if( n<m ){ // #在$后面 本次内容即完整的一段
                Terminate = recvMsg.mid(n, m-n+1); // 打包完整，走你
                m_storeNow.clear();
            }else if( n>m ){ // #在$前面，本次打包内容有 正在打包的尾 和下一次要打包的头
                m_storeNow += recvMsg.left(m+1); // 加上尾OK 这次打包完整
                Terminate = m_storeNow; // 把包包放到流通盒中
                m_storeNow.clear(); // 清空一下包包
                QByteArray newMsg = recvMsg.right(recvMsg.size() - n); // 把$后面的内容放到下一个要打的包中
                m_storeNow = newMsg; // 把下一个包的内容到现在这个包里，继续等待快递给数据把。
            }
        }
        
        else if(-1 != recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 仅含有$
            // 新的开始, 把正在打的包刷新一下
            m_storeNow.clear();
            int n = recvMsg.indexOf("$"); // 找到$的位置
            m_storeNow = recvMsg.right( recvMsg.size()-n ); // 把$之后的内容放到包中
        }
        
        else if(-1 == recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 仅仅含有#
            // 说明快递送来了最后的零件
            int m = recvMsg.indexOf("#");
            m_storeNow += recvMsg.left(m+1); // 内容补充完整
            Terminate = m_storeNow; // 把包包放到流通盒里中
            m_storeNow.clear(); // 清空一下包包
        }
        
        else if(-1 == recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 即不含$，且不含#
            m_storeNow += recvMsg; //把这次快递过来的东西放到包包里去
        }
    }
    
    else if( -1 == m_storeNow.indexOf("$") ){ //现在的包包要么是空包，要么打包错误
        m_storeNow.clear(); // 既然是空包那就刷新一次，如果是错误包，那么更要刷新一次了
        
        if(-1 != recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 含有$，且含有#
            int n = recvMsg.indexOf("$");
            int m = recvMsg.indexOf("#");
            if( n<m ){ // #在$后面，本次内容即为完整的一段
                Terminate = recvMsg.mid(n, m-n+1); // 打包完整，走你
            }else if( n>m ){ // #在$后面，包包为空，所以只需要截取$后的内容就OK了
                m_storeNow = recvMsg.right( recvMsg.size()-n );
            }
        }
        
        else if(-1 != recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 仅含有$
            int n = recvMsg.indexOf("$"); //找到$的位置
            m_storeNow = recvMsg.right( recvMsg.size()-n ); //把$之后的内容放到包里
        }
        
        else if(-1 == recvMsg.indexOf("$") && -1 != recvMsg.indexOf("#")){ // 仅含有#
            // 说明快递送来了最后的零件
            // 但是正在打包的包包没有头， 所以这次快递拒绝接受
        }
        
        else if(-1 == recvMsg.indexOf("$") && -1 == recvMsg.indexOf("#")){ // 即不含$，且不含#
            // 说明快递送来了中间的零件
            // 但是正在打包的包包没有头，所以这次快递拒绝接受
        }
    }
    return Terminate;
}

// 有头无尾，报文中没有和头一样的字符，长度不固定 
QByteArray recvDataFlow(QByteArray recvMsg)
{
    QByteArray Terminate;
    int pHead = recvMsg.indexOf("$");
    
    // 如果当前的信息中没有$，且当前的包为空  此时的信息为无用信息
    if( pHead == -1 && m_storeNow.isEmpty()){
        return Terminate;
    }
    
    // 如果当前的信息中没有$，但当前的包不为空  此时的信息为中段信息，加进来
    if( pHead == -1 && !m_storeNow.isEmpty()){
        m_storeNow += recvMsg;
        return Terminate;
    }
    
    // 如果当前的信息中有$，且当前的包为空  此时的信息为开头信息，加进来
    if( pHead != -1 && m_storeNow.isEmpty()){
        m_storeNow = recvMsg.right( recvMsg.length() - pHead);
        return Terminate;
    }
    
    // 如果当前的信息中有$，且包不为空  此时的信息有第二段信息以及第一段信息的尾
    if( pHead != -1 && !m_storeNow.isEmpty()){
        m_storeNow += recvMsg.left(pHead);
        // 判断当前的信息是否有用
        if(m_storeNow.left(5) == "$TXXX" || m_storeNow.left(5) == "$DWXX"){
            Terminate = m_storeNow;
        }
        // 将$以及之后的信息放到新包中
        m_storeNow.clear();
        m_storeNow = recvMsg.right( recvMsg.length() - pHead);
        return Terminate;
    }
    
    return  Terminate;
}

// 有头无尾，报文中有和头一样的字符，长度固定
QByteArray recvDataFlow(QByteArray recvMsg)
{
    // 判断接受完信息之后，当前的长度，如果当前长度>29
    // 找Loc，如果能找到Loc，看看从size-L的距离有没有大于等于29
    // 如果大于29，就只取29，然后把后面给留在下一个包中
    // 如果等于29，就取29，然后把包清空
    // 如果小于29，就继续等待
    QByteArray Terminate;
    
    m_storeNow += recvMsg;
    int pHead = m_storeNow.indexOf("Rem");
    if( m_storeNow.size() - pHead > 29){
        Terminate = m_storeNow.mid(pHead, 29);
        QByteArray tmp = m_storeNow.right(m_storeNow.size() - pHead - 29);
        m_storeNow.clear();
        m_storeNow = tmp;
    }
    
    else if( m_storeNow.size() - pHead == 29){
        Terminate = m_storeNow;
        m_storeNow.clear();
    }
    return  Terminate;
}
