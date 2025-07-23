//
//  GameScene.swift
//  EggDropOdyssey
//
//  Created by Baig, Muhammad on 11/9/2023
//
// All features on

import SpriteKit
import GameplayKit


enum GameState {
    case start
    case playing
    case gameOver
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var background : SKSpriteNode!
    private var chicken: SKSpriteNode!
    private var basket: SKSpriteNode!
    private var movingRight: Bool = true
    private var egg: SKSpriteNode!
    private var egg2: SKSpriteNode!
    private var gameover: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var titleAnimation: SKAction!
    var currentMovementDuration: TimeInterval = 5.0
    private var endButton: SKSpriteNode!
    var hasStarted = false
    
    private var startBtn = SKSpriteNode()
    private var currentState: GameState = .start
    
    private var score = 0
    private var lives = 3
    
    override func didMove(to view: SKView) {
        if !hasStarted {
                    playStartMusic()
                    setupStartScreen()
                    hasStarted = true
                }
    }
    
    func playStartMusic() {
        // Load the sound file and play it
        let sound = SKAction.playSoundFileNamed("start_music.mp3", waitForCompletion: false)
        run(sound)
    }
    
    func setupStartScreen() {
        currentState = .start

        // Background setup
        background = SKSpriteNode(imageNamed: "farm")
        background.position = CGPoint(x: 0, y: 0)
        background.size = self.frame.size
        background.zPosition = -1
        self.addChild(background)
        
        
        setupTitleAnimation()

        makeStartBtn()
    }

    func makeStartBtn() {
        startBtn = SKSpriteNode(imageNamed: "start")

        startBtn.position = CGPoint(x: self.frame.midX + 5, y: self.frame.midY - 100)

        startBtn.zPosition = 10

        let scaleUp = SKAction.scale(to: 1.0, duration: 1.5)
        let scaleDown = SKAction.scale(to: 1.05, duration: 1.5)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        startBtn.run(SKAction.repeatForever(scaleSequence))

        self.addChild(startBtn)
    }

    
    func setupTitleAnimation() {
        let titleImages = [
            "title1", "title2", "title3", "title4", "title5",
            "title6", "title7", "title8", "title9", "title10",
            "title11", "title12", "title13", "title14"
        ]

        let titleTextures = titleImages.map { SKTexture(imageNamed: $0) }

        titleAnimation = SKAction.animate(with: titleTextures, timePerFrame: 0.4)


        let animatedTitle = SKSpriteNode(texture: titleTextures.first)
        animatedTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        animatedTitle.zPosition = 10
        animatedTitle.setScale(1.8)
        animatedTitle.run(SKAction.repeatForever(titleAnimation))


        self.addChild(animatedTitle)
    }
    
    func startStorytellingAnimation() {
        let storyScene = StoryScene(size: self.size)
        storyScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 1.0)

        self.view?.presentScene(storyScene, transition: transition)
    }


    func startGame() {
        currentState = .playing
        score = 0
        lives = 3
        currentMovementDuration = 5.0
        
        // Remove start button
        removeAllChildren()
        
        // Background setup
        background = SKSpriteNode(imageNamed: "farm")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        background.scale(to: self.size)
        self.addChild(background)
        
        //Chicken Setup
        chicken = SKSpriteNode(imageNamed: "chicken")
        chicken.position = CGPoint(x: frame.minX, y: frame.maxY - 320)
        chicken.size.height = 320
        chicken.size.width = 200
        addChild(chicken)
        
        let moveRight = SKAction.moveTo(x: frame.maxX, duration: 5.0)
        let moveLeft = SKAction.moveTo(x: frame.minX, duration: 5.0)
        let bounceSequence = SKAction.sequence([moveRight, moveLeft])
        let bounceForever = SKAction.repeatForever(bounceSequence)
        
        chicken.run(bounceForever)


        //Basket Setup
        basket = SKSpriteNode(imageNamed: "basket")
        basket.position = CGPoint(x: frame.midX, y: frame.minY + 300)
        basket.size.height = 400
        basket.size.width = 250
        addChild(basket)
        
        updateMovement(node: basket)
        
        
        //Score Setup
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: frame.minX + 150, y: frame.maxY - 100)
        addChild(scoreLabel)

        //Lives Setup
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.text = "Lives: \(lives)"
        livesLabel.fontSize = 30
        livesLabel.fontColor = SKColor.black
        livesLabel.position = CGPoint(x: frame.maxX - 150 , y: frame.maxY - 100)
        addChild(livesLabel)
        
    }
    
    //Update movement for the basket needed function so duration could decrease
    func updateMovement(node: SKSpriteNode) {
        let currentX = basket.position.x
        let targetX = movingRight ? frame.maxX : frame.minX

        // Calculate the remaining distance to the target
        let distanceToTarget = abs(currentX - targetX)

        // Calculate the duration based on the remaining distance
        let duration = (distanceToTarget / frame.width) * currentMovementDuration

        let moveAction = SKAction.moveTo(x: targetX, duration: TimeInterval(duration))
        let completionAction = SKAction.run {
            // Toggle the direction
            self.movingRight.toggle()
            self.updateMovement(node: self.basket)
        }

        let sequence = SKAction.sequence([moveAction, completionAction])
        basket.run(sequence, withKey: "moving")
    }


    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if touchedNode == startBtn {
            if currentState == .gameOver {
                removeAllChildren()
                setupStartScreen()
            } else {
                startStorytellingAnimation()
            }
        } else if touchedNode == endButton {
            startGame()
        }
        else if currentState == .playing {
            if egg == nil {
                egg = SKSpriteNode(imageNamed: "egg")
                //might need to change
                egg!.size.height = 100
                egg!.size.width = 100
                egg!.position = chicken.position
                addChild(egg!)
                
                // Apply gravity to the egg
                egg!.physicsBody = SKPhysicsBody(circleOfRadius: egg!.size.width / 2)
                egg!.physicsBody?.affectedByGravity = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        guard currentState == .playing else { return }
        // Check if the egg has missed the basket
        if let egg = egg, egg.position.y < frame.minY + 130 {
            egg2 = SKSpriteNode(imageNamed: "egg2")
            egg2.position = egg.position
            egg2.size.height = 80
            egg2.size.width = 80
            
            egg.removeFromParent()
            self.egg = nil
            self.addChild(egg2)


            lives -= 1
            livesLabel.text = "Lives: \(lives)"
            if lives <= 0 {
                setupGameOverScreen()
            }
        }

        // Check if the egg is in the basket
        if let egg = egg, egg.intersects(basket) {
            score += 1
            scoreLabel.text = "Score: \(score)"
            egg.removeFromParent()
            self.egg = nil

            //Can change just for now
            currentMovementDuration = max(currentMovementDuration * 0.70, 1.0)

            updateMovement(node: basket)


        }
    }
    
    func setupGameOverScreen() {
        currentState = .gameOver

        // Remove all nodes
        removeAllChildren()

     // Add a black background
     //   let blackBackground = SKSpriteNode(color: .black, size: self.size)
     //   blackBackground.position = CGPoint(x: frame.midX, y: frame.midY)
     //   blackBackground.zPosition = -1
     //   addChild(blackBackground)
        
        let overBackground = SKSpriteNode(imageNamed: "enbt")
        overBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        overBackground.size = self.frame.size
        overBackground.zPosition = -1
        overBackground.scale(to: self.size)
        addChild(overBackground)
        
        //gameOver = SKSpriteNode(imageNamed: "gameover")
        
        let title = SKSpriteNode(imageNamed: "gameovertitle")
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        title.zPosition = 10
        title.setScale(10)
        addChild(title)
        
        // Game over label setup
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Score: \(score)"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(gameOverLabel)
        
        endButton = SKSpriteNode(imageNamed: "gameover")
        endButton.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        endButton.zPosition = 10
        endButton.setScale(7)
        addChild(endButton)
    }

}

